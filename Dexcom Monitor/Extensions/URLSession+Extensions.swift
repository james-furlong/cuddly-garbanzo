//
//  URLSession+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 2/1/2023.
//

import Foundation
import Combine

//extension URLSession: NetworkSession {
//    func publisher(for request: URLRequest, token: Token?) -> AnyPublisher<Data, Error> {
//        var mutableRequest = request
//        if let token = token {
//            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
//        }
//
//        return dataTaskPublisher(for: request)
//            .tryMap { result in
//                #if DEBUG
//                let bodyString: String = result.data.formattedString() ?? ""
//                var responseString: String = ""
//                responseString += "<---- Api Response --->"
//                responseString += "\n---- [\(request.httpMethod ?? "GET")] \(request.url?.absoluteString ?? "No Url")"
//                responseString += "\n---- Status Code: \(((result.response as? HTTPURLResponse)?.statusCode ?? -1))"
//                responseString += (bodyString.isEmpty ? "" : "\n---- Body:\n\(bodyString)")
//                responseString += "\n<---- End Response --->"
//                Injector.log.verbose(responseString)
//                #endif
//
//                if let networkError: NetworkError = NetworkError(
//                    statusCode: (result.response as? HTTPURLResponse)?.statusCode,
//                    data: result.data,
//                    urlPath: request.url?.path
//                ) {
//                    throw networkError
//                }
//
//                guard let data = result.data else {
//                    throw NetworkError.invalidData
//                    return
//                }
//
//                return data
//            }
//            .eraseToAnyPublisher()
//    }
//}
