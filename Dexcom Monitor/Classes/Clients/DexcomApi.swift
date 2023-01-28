//
//  DexcomApi.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation
import Combine

struct DexcomAPI: Api {
    var clientId: String = "q7QlbWrpLBWNxsoNqqcHTxmMIYyPJYZe"
    var clientSecret: String = "ssSn2oayJVGHvnPJ"
    var redirectUri: String = "monitor://"
    
    func verifyAuthorization(token: String) -> AnyPublisher<AuthTokenResponse, Error> {
        Injector.apiClient.retrieveAuthToken(
            request: AuthTokenRequest(
                code: token,
                id: clientId,
                secret: clientSecret,
                redirectUri: redirectUri
            )
        )
    }
}
