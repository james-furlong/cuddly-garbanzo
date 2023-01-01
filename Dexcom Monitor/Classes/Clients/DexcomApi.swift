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
    let redirectUri: String = "monitor"
    
    func verifyAuthorization(token: String) -> AnyPublisher<AuthTokenResponse, Error> {
        Future { promise in
            Injector.apiClient.retrieveAuthToken(
                request: AuthTokenRequest(
                    code: token,
                    id: id,
                    secret: secret,
                    redirectUrl: redirectUri
                ),
                success: { data in
                    promise(.success(data))
                },
                error: { error in
                    promise(.failure(error))
                }
            )
        }
        .compactMap({ $0 })
        .tryMap { try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
        .decode(type: AuthTokenResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
//    func refreshToken() -> Future<Bool, Error> {
//        
//    }
}
