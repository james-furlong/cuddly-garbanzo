//
//  AuthTokenRequest.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation

struct AuthTokenRequest {
    let code: String
    let id: String
    let secret: String
    let type: String = "authorization_code"
    let redirectUrl: String
}
