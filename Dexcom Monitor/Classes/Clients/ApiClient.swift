//
//  ApiClient.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation
import Combine

protocol ApiClientType {
    
}

extension Network {
    struct ApiClient: ApiClientType {
        
        private static let timeoutInterval: TimeInterval = 15
        
        
        
        
        private func get(_ endpoint: Endpoint) -> Future<URLRequest, Error> {
            return Future { promise in
                do {
                    let request = try generateRequest(method: .get, endpoint: endpoint)
                    promise(.success(request))
                }
                catch {
                    promise(.failure(NetworkError.invalidUrl))
                }
            }
        }
        
        private func post<T>(_ endpoint: Endpoint, _ body: T) -> Future<URLRequest, Error> where T: Encodable {
            return Future { promise in
                do {
                    let bodyData = generateData(for: body)
                    let request = try generateRequest(method: .post, endpoint: endpoint, bodyData: bodyData)
                    promise(.success(request))
                }
                catch {
                    promise(.failure(NetworkError.invalidUrl))
                }
            }
        }
        
        private func generateData<T>(for body: T) -> Data? where T: Encodable {
            guard let encodedData: Data = body.encodedToData() else { return nil }

            return encodedData
        }
        
        private func generateRequest(method: HTTPMethod, endpoint: Endpoint, bodyData: Data? = nil) throws -> URLRequest {
            let headers = generateHeaders(hasBody: bodyData != nil)
            let urlString = self.urlForEndpoint(endpoint)
            
            guard let url = URL(string: urlString) else {
               throw NetworkError.invalidUrl
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

    fileprivate func generateHeaders(hasBody: Bool) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        // TODO: Update header values here
        
        return headers
    }
}
