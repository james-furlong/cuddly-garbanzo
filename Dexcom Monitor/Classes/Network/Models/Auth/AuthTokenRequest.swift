//
//  AuthTokenRequest.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation

struct AuthTokenRequest: Encodable, UrlEncodable {
    let code: String
    let id: String
    let secret: String
    let type: String = "authorization_code"
    let redirectUri: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case id = "client_id"
        case secret = "client_secret"
        case type = "grant_type"
        case redirectUri = "redirect_uri"
    }
    
    var bodyComponents: URLComponents {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: CodingKeys.type.rawValue, value: type),
            URLQueryItem(name: CodingKeys.code.rawValue, value: code),
            URLQueryItem(name: CodingKeys.redirectUri.rawValue, value: redirectUri),
            URLQueryItem(name: CodingKeys.id.rawValue, value: id),
            URLQueryItem(name: CodingKeys.secret.rawValue, value: secret)
        ]
        
        return components
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.code, forKey: .code)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.secret, forKey: .secret)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.redirectUri, forKey: .redirectUri)
    }
}
