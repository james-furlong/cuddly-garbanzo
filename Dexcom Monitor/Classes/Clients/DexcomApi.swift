//
//  DexcomApi.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation
import Combine

struct DexcomAPI {
    let id: String = "q7QlbWrpLBWNxsoNqqcHTxmMIYyPJYZe"
    let secret: String = "ssSn2oayJVGHvnPJ"
    let redirectUri: String = "monitor://"
    
    func verifyAuthorization(token: String) -> AnyPublisher<AuthTokenResponse, Error> {
        Injector.apiClient.retrieveAuthToken(
            request: AuthTokenRequest(
                code: token,
                id: id,
                secret: secret,
                redirectUri: redirectUri
            )
        )
    }
}
