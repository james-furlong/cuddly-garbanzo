//
//  Environment.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

protocol Environment {
    var target: TargetEnvironment { get }
    var session: URLSession { get }

    var httpProtocol: String { get }
    var baseUrl: String { get }
    var version: String { get }

    var apiClient: ApiClientType { get }
    var auth: AuthClient { get }
}

// MARK: - Target Environment

enum TargetEnvironment: Int, CaseIterable {
    case mock = 1
    case staging = 2
    case production = 3
    
    var title: String {
        switch self {
            case .mock: return "Mock"
            case .staging: return "Staging"
            case .production: return "Production"
        }
    }

    func createEnvironment() -> Environment {
        switch self {
            case .mock: return MockEnvironment()
            case .staging: return StagingEnvironment()
            case .production: return ProductionEnvironment()
        }
    }
}

// MARK: - Environment Configurations

struct MockEnvironment: Environment {
    let target: TargetEnvironment = .mock
    let session: URLSession = URLSession.shared

    let httpProtocol: String = "https"
    let baseUrl: String = ""
    let version: String = "v1"

    let apiClient: ApiClientType = Network.ApiClient()//MockApiClient()
    let auth: AuthClient = AuthClient()
}

struct StagingEnvironment: Environment {
    let target: TargetEnvironment = .staging
    let session: URLSession = URLSession.shared

    let httpProtocol: String = "https"
    let baseUrl: String = "sandbox-api.dexcom.com"
    let version: String = "v2"
    
    let apiClient: ApiClientType = Network.ApiClient()
    let auth: AuthClient = AuthClient()
}

struct ProductionEnvironment: Environment {
    let target: TargetEnvironment = .production
    let session: URLSession = URLSession.shared

    let httpProtocol: String = "https"
    let baseUrl: String = "api.dexcom.com"
    let version: String = "v2"
    
    let apiClient: ApiClientType = Network.ApiClient()
    let auth: AuthClient = AuthClient()
}
