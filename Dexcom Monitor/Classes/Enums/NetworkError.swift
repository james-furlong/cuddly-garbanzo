//
//  NetworkError.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import Combine

enum NetworkError: Error {
    case invalidUrl
    
    var errorDescription: String? {
        switch self {
            case .invalidUrl: return "The URL provided was invalid."
        }
    }
}

