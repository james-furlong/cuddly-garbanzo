//
//  Endpoint.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation

enum Endpoint {
    case authentication
    
    var path: String {
        switch self {
            case .authentication: return "v2/oauth2/token"
        }
    }
}
