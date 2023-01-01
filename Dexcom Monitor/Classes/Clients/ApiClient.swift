//
//  ApiClient.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation
import Combine

protocol ApiClientType {
    func retrieveAuthToken(request: AuthTokenRequest, success: @escaping (Data) -> (), error: @escaping (NetworkError) -> ())
//    func refreshAuthToken(request: AuthRefreshRequest, success: @escaping (Data) -> (), error: @escaping (NetworkError) -> ())
}

extension Network {
    struct ApiClient: ApiClientType {
        
        private static let timeoutInterval: TimeInterval = 15
        
        func retrieveAuthToken(request: AuthTokenRequest, success: @escaping (Data) -> (), error: @escaping (NetworkError) -> ()) {
            get(.authToken(request: request))
                .executed(in: Injector.session) { data, err in
                    if let responseData = data {
                        success(responseData)
                    }
                    
                    error(err as? NetworkError ?? NetworkError.api)
                }
        }
        
//        func refreshAuthToken(request: <<error type>>, success: @escaping (Data) -> (), error: @escaping (NetworkError) -> ()) {
//            get(
//        }
        
        // MARK: - Functions
        
        private func get(_ endpoint: Endpoint) -> URLRequest? {
            generateRequest(method: .get, endpoint: endpoint)
        }
        
        private func post<T>(_ endpoint: Endpoint, _ body: T) -> URLRequest? where T: Encodable {
            generateRequest(method: .post, endpoint: endpoint, bodyData: generateData(for: body))
        }
        
        private func generateData<T>(for body: T) -> Data? where T: Encodable {
            guard let encodedData: Data = body.encodedToData() else { return nil }

            return encodedData
        }
        
        private func generateRequest(method: HTTPMethod, endpoint: Endpoint, bodyData: Data? = nil) -> URLRequest? {
            let headers = generateHeaders(hasBody: bodyData != nil, requiresAuth: endpoint.requiresAuth)
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

    fileprivate func generateHeaders(hasBody: Bool, requiresAuth: Bool) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        headers[HTTPHeader.contentType.rawValue] = "application/x-www-form-urlencoded"
        
        if requiresAuth {
            let authToken = ""
            headers[HTTPHeader.authorization.rawValue] = "Bearer \(authToken)"
        }
        
        return headers
    }
}

// MARK: - URL Request

public extension Optional where Wrapped == URLRequest {
    func executed(in session: URLSession, completionHabdler: @escaping (Data?, Error?) -> Void) {
        guard let request = self else {
            completionHabdler(nil, NetworkError.invalidData)
            return
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
        
        let task = session.dataTask(with: request) { maybeData, response, error in
            #if DEBUG
            let bodyString: String = maybeData?.formattedString() ?? ""
            var responseString: String = ""
            responseString += "<---- Api Response -- \(requestUuid) -->"
            responseString += "\n---- [\(request.httpMethod ?? "GET")] \(request.url?.absoluteString ?? "No Url")"
            responseString += "\n---- Status Code: \(((response as? HTTPURLResponse)?.statusCode ?? -1))"
            responseString += (bodyString.isEmpty ? "" : "\n---- Body:\n\(bodyString)")
            responseString += "\n<---- End Response -- \(requestUuid) -->"
            #endif
            
            if let error = error {
                completionHabdler(nil, error)
            }
            
            if let networkError: NetworkError = NetworkError(
                statusCode: (response as? HTTPURLResponse)?.statusCode,
                data: maybeData,
                urlPath: request.url?.path
            ) {
                completionHabdler(nil, networkError)
            }
            
            guard let data: Data = maybeData else {
                completionHabdler(nil, NetworkError.invalidData)
                return
            }
            
            completionHabdler(data, nil)
        }
    }
}
