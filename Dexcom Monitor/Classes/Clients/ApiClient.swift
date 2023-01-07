//
//  ApiClient.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation
import Combine

protocol ApiClientType {
    func retrieveAuthToken(request: AuthTokenRequest) -> AnyPublisher<AuthTokenResponse, Error>
    func refreshAuthToken(request: AuthTokenRequest) -> AnyPublisher<AuthTokenResponse, Error>
    
    func getGlucoseValues(request: GlucoseValuesRequest) -> AnyPublisher<GlucoseValuesResponse, Error>
}

extension Network {
    struct ApiClient: ApiClientType {
        
        private static let timeoutInterval: TimeInterval = 15

        func retrieveAuthToken(request: AuthTokenRequest) -> AnyPublisher<AuthTokenResponse, Error> {
            post(.authToken, request)
                .executed(in: Injector.session)
                .mapError { $0 as! NetworkError }
                .decode(type: AuthTokenResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        func refreshAuthToken(request: AuthTokenRequest) -> AnyPublisher<AuthTokenResponse, Error> {
            post(.authRefresh, request)
                .executed(in: Injector.session)
                .mapError { $0 as! NetworkError }
                .decode(type: AuthTokenResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        func getGlucoseValues(request: GlucoseValuesRequest) -> AnyPublisher<GlucoseValuesResponse, Error> {
            return Injector.auth.validToken()
                .flatMap { token in
                    get(.glucoseValues(request))
                        .executed(in: Injector.session, token: token)
                }
                .tryCatch { error -> AnyPublisher<Data, Error> in
                    guard let networkError: NetworkError = error as? NetworkError, networkError == .unauthorized else {
                        throw error
                    }
                    
                    return Injector.auth.validToken(forceRefresh: true)
                        .flatMap { token in
                            get(.glucoseValues(request))
                                .executed(in: Injector.session, token: token)
                        }
                        .eraseToAnyPublisher()
                }
                .decode(type: GlucoseValuesResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        // MARK: - Functions
        
        private func get(_ endpoint: Endpoint) -> URLRequest? {
            generateRequest(method: .get, endpoint: endpoint)
        }
        
        private func post<T>(_ endpoint: Endpoint, _ body: T) -> URLRequest? where T: Encodable {
            generateRequest(method: .post, endpoint: endpoint, bodyData: generateData(for: body, with: endpoint))
        }
        
        private func generateData<T>(for body: T, with endpoint: Endpoint) -> Data? where T: Encodable {
            let encodedData: Data?
            if let urlBody = body as? UrlEncodable {
                encodedData = urlBody.bodyComponents.query?.data(using: .utf8)
            }
            else {
                encodedData = body.encodedToData()
            }
            
            return encodedData
        }
        
        private func generateRequest(method: HTTPMethod, endpoint: Endpoint, bodyData: Data? = nil) -> URLRequest? {
            let headers = generateHeaders(hasBody: bodyData != nil, requiresAuth: endpoint.requiresAuth, bodyIsUrlEncoded: endpoint.isUrlEncodedBody)
            let urlString = self.urlForEndpoint(endpoint)
            
            guard let url = URL(string: urlString) else {
                return nil
            }
            
            // Generate the request
            var request = URLRequest(
                url: url,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: ApiClient.timeoutInterval
            )
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = bodyData

            return request
        }
    }
}

// MARK: - Request Construction

extension ApiClientType {
    func urlForEndpoint(_ endpoint: Endpoint) -> String {
        let endpointPath: String = endpoint.path
        return "\(Injector.httpProtocol)://\(Injector.baseUrl)/\(Injector.version)/\(endpointPath)"
    }

    fileprivate func generateHeaders(hasBody: Bool, requiresAuth: Bool, bodyIsUrlEncoded: Bool) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        headers[HTTPHeader.contentType.rawValue] = bodyIsUrlEncoded ? "application/x-www-form-urlencoded" : "application/json"
        
        if requiresAuth {
            let authToken = ""
            headers[HTTPHeader.authorization.rawValue] = "Bearer \(authToken)"
        }
        
        return headers
    }
}

// MARK: - URL Request

public extension Optional where Wrapped == URLRequest {
    internal func executed(in session: URLSession, token: AuthTokenResponse? = nil) -> AnyPublisher<Data, Error> {
        guard var request = self else {
            return Fail(error: NetworkError.invalidData).eraseToAnyPublisher()
        }
        if let token = token {
            request.setValue("Bearer \(token.authToken)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
        
        #if DEBUG
        let requestUuid = UUID().uuidString
        let bodyString: String = request.httpBody?.formattedString() ?? ""
        var requestString: String = ""
        requestString += "<---- API Request -- \(requestUuid) -->"
        requestString += "\n---- [\(request.httpMethod ?? "GET")] \(request.url?.absoluteString ?? "No URL")"
        requestString += "\n---- Headers:"
        requestString += (request.allHTTPHeaderFields ?? [:])
            .reduce(into: "") { result, next in
                result = "\(result)\n\(next.key): \(next.value)"
            }
        requestString += (bodyString.isEmpty ? "" : "\n---- Body:\n\(bodyString)")
        requestString += "\n----> End Request -- \(requestUuid) -->"
        Injector.log.verbose(requestString)
        #endif
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                #if DEBUG
                let bodyString: String = result.data.formattedString()
                var responseString: String = ""
                responseString += "<---- Api Response --->"
                responseString += "\n---- [\(request.httpMethod ?? "GET")] \(request.url?.absoluteString ?? "No Url")"
                responseString += "\n---- Status Code: \(((result.response as? HTTPURLResponse)?.statusCode ?? -1))"
                responseString += (bodyString.isEmpty ? "" : "\n---- Body:\n\(bodyString)")
                responseString += "\n<---- End Response --->"
                Injector.log.verbose(responseString)
                #endif

                if let networkError: NetworkError = NetworkError(
                    statusCode: (result.response as? HTTPURLResponse)?.statusCode,
                    data: result.data,
                    urlPath: request.url?.path
                ) {
                    throw networkError
                }

                return result.data
            }
            .eraseToAnyPublisher()
    }
}
