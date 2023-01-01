//
//  AuthRefreshRequest.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation

struct AuthRefreshRequest {
    let type: String = "refresh_token"
    let redirectUri: String
}
