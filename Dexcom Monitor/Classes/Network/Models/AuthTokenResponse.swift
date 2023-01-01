//
//  AuthTokenResponse.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation
struct AuthTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: TokenType
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresIn
        case tokenType
        case refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        tokenType = try container.decode(TokenType.self, forKey: .tokenType)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        
        // TODO: Cache the token
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}

enum TokenType: String, Codable {
    case bearer = "Bearer"
}
