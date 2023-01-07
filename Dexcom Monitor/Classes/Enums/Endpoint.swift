//
//  Endpoint.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation

enum Endpoint {
    case authToken
    case authRefresh
    case glucoseValues(GlucoseValuesRequest)
    
    var path: String {
        switch self {
            case .authToken: return "oauth2/token"
            case .glucoseValues(let request): return "users/self/egvs?startDate=\(request.startDateTime)&endDate=\(request.endDateTime)"
            default: return ""
        }
    }
    
    var requiresAuth: Bool {
        switch self {
            case .authToken: return false
            default: return true
        }
    }
    
    var isUrlEncodedBody: Bool {
        switch self {
            case .authToken, .authRefresh: return true
            default: return false
        }
    }
}
