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
    case glucoseValues(QueryRequest)
    case calibrations(QueryRequest)
    case dataRange
    case devices(QueryRequest)
    case events(QueryRequest)
    case statistics(QueryRequest)
    
    var path: String {
        switch self {
            case .authToken:
                return "oauth2/token"
                
            case .glucoseValues(let request):
                return "users/self/egvs?\(request.query)"
                
            case .calibrations(let request):
                return "users/self/calibrations?\(request.query)"
                
            case .dataRange:
                return "users/self/dataRange"
                
            case .devices(let request):
                return "users/self/devices?\(request.query)"
                
            case .events(let request):
                return "users/self/events?\(request.query)"
                
            case .statistics(let request):
                return "users/self/statistics?\(request.query)"
                
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
