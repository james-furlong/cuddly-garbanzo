//
//  Endpoint.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation

enum Endpoint {
    case authToken(request: AuthTokenRequest)
    case authRefresh(request: AuthRefreshRequest)
    
    var path: String {
        switch self {
            case .authToken(let request):
                return "v2/oauth2/token?client_id=\(request.id)&client_secret=\(request.secret)&code=\(request.code)&grant_type=\(request.type)&redirect_uri=\(request.redirectUrl)"
            default: return ""
        }
    }
    
    var requiresAuth: Bool {
        switch self {
            case .authToken: return false
            default: return true
        }
    }
}
