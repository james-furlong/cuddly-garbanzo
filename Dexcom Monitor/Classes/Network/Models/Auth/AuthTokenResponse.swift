//
//  AuthTokenResponse.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation
struct AuthTokenResponse: Codable {
    let authToken: String
    let expiresIn: Int
    let tokenType: TokenType
    let refreshToken: String
    
    var isValid: Bool { return true }
    
    enum CodingKeys: String, CodingKey {
        case authToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        authToken = try container.decode(String.self, forKey: .authToken)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        tokenType = try container.decode(TokenType.self, forKey: .tokenType)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        
        Injector.cache.cache(authToken, forKey: Constants.KeychainDataKey.authToken)
        Injector.cache.cache(refreshToken, forKey: Constants.KeychainDataKey.refreshToken)
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(authToken, forKey: .authToken)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}

enum TokenType: String, Codable {
    case bearer = "Bearer"
}
