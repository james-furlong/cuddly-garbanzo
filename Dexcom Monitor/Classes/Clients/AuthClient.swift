//
//  AuthClient.swift
//  Dexcom Monitor
//
//  Created by James on 2/1/2023.
//

import Foundation
import Combine

class AuthClient {
    private let currentToken: AuthTokenResponse?
    private let queue: DispatchQueue = DispatchQueue(label: "AuthClient.\(UUID().uuidString)")
    private let api: DexcomAPI = DexcomAPI()
    
    init(token: AuthTokenResponse? = nil) {
        self.currentToken = token
    }
    
    // This publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<AuthTokenResponse, Error>?
        
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<AuthTokenResponse, Error> {
        return queue.sync { [weak self] in
            
            // A token refresh is already in progress
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            // There is no token at all
            guard let token = self?.currentToken else {
                return Fail(error: NetworkError.unauthorized)
                    .eraseToAnyPublisher()
            }

            // There is already a valid token
            if token.isValid, !forceRefresh {
                return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            // The token is expired and needs to be refreshed
            let publisher = Injector.apiClient
                .refreshAuthToken(request: AuthTokenRequest(
                    code: token.refreshToken,
                    id: api.id,
                    secret: api.secret,
                    redirectUri: api.redirectUri
                )
            )
            
            self?.refreshPublisher = publisher
            return publisher
        }
    }
}
