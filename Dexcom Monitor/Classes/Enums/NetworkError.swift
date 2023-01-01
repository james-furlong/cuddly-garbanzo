//
//  NetworkError.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import Combine
import Foundation

enum NetworkError: Error {
    // Request errors
    case invalidUrl
    case parsing(description: String)
    
    // General errors
    case timeOut
    case noNetwork
    case invalidData
    
    // Specific errors
    case badRequest
    case unauthorized
    case notFound
    case tooManyRequests
    case internalServerError
    case api
    
    var errorDescription: String? {
        switch self {
            case .invalidUrl: return "The URL provided was invalid."
            case .parsing(let description): return description
            case .timeOut: return "Response took too long"
            case .noNetwork: return "No network found"
            case .invalidData: return "Data is not valid"
            case .badRequest: return "Bad request"
            case .unauthorized: return "User is not authorized"
            case .notFound: return "URL not found"
            case .tooManyRequests: return "Too many requests"
            case .internalServerError: return "Internal server error"
            case .api: return "General API error"
        }
    }
}

extension NetworkError {
    init(error: NSError) {
        switch error.code {
            case NSURLErrorTimedOut: self = .timeOut
            case NSURLErrorNotConnectedToInternet: self = .noNetwork
            default: self = .api
        }
    }

    init?(statusCode: Int?, data: Data?, urlPath: String?) {
        guard let statusCode: Int = statusCode, statusCode == 200 || statusCode == 302 else {
            return nil
        }

        // TODO: Handle more codes
        switch statusCode {
            case 400: self = .badRequest
            case 401: self = .unauthorized
            case 404: self = .notFound
            case 429: self = .tooManyRequests
            case 500: self = .internalServerError
            
            default: self = .api
        }
    }
}

