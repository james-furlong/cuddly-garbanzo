//
//  AuthClient.swift
//  Dexcom Monitor
//
//  Created by James on 2/1/2023.
//

import Foundation
import Combine
import JWTDecode

class AuthClient {
    private var tokenIsRefreshing: Bool = false
    private let api: DexcomAPI = DexcomAPI()
    
    var userIsLoggedIn: Bool {
        Injector.cache.contains(key: Constants.KeychainDataKey.authToken)
    }
    
    func signRequest(request: URLRequest?) -> URLRequest? {
        if tokenIsRefreshing {
            holdForRefreshing()
        }
        
        guard var token = Injector.cache.string(forKey: Constants.KeychainDataKey.authToken) else {
            return nil
        }
        let expiry = (try? decode(jwt: token).expiresAt?.timeIntervalSince1970) ?? Date().timeIntervalSince1970
        if Date().timeIntervalSince1970 < (expiry - 60) {
            Injector.apiClient
                .refreshAuthToken(
                    request: AuthTokenRequest(
                        code: token,
                        id: api.clientId,
                        secret: api.clientSecret,
                        redirectUri: api.redirectUri
                    ))
                .sink(
                    receiveCompletion: { error in
                        
                    },
                    receiveValue: { [unowned self] response in
                        token = response.authToken
                        self.tokenIsRefreshing = false
                    }
                )
                .cancel()
            
            holdForRefreshing()
        }
    
        guard var urlRequest = request else { return nil }
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        
        return urlRequest
    }
    
    private func holdForRefreshing() {
        if tokenIsRefreshing {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] timer in
                self?.holdForRefreshing()
            }
        }
    }
    
    // This publisher is shared amongst all calls that request a token refresh
//    private var refreshPublisher: AnyPublisher<AuthTokenResponse, Error>?
//
//    func validToken(forceRefresh: Bool = false) -> AnyPublisher<AuthTokenResponse, Error> {
//        return queue.sync { [weak self] in
//
//            // A token refresh is already in progress
//            if let publisher = self?.refreshPublisher {
//                return publisher
//            }
//
//            // There is no token at all
//            guard let token = self?.currentToken else {
//                return Fail(error: NetworkError.unauthorized)
//                    .eraseToAnyPublisher()
//            }
//
//            // There is already a valid token
//            if token.isValid, !forceRefresh {
//                return Just(token)
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
//
//            // The token is expired and needs to be refreshed
//            let publisher = Injector.apiClient
//                .refreshAuthToken(request: AuthTokenRequest(
//                    code: token.refreshToken,
//                    id: api.clientId,
//                    secret: api.clientSecret,
//                    redirectUri: api.redirectUri
//                )
//            )
//
//            self?.refreshPublisher = publisher
//            return publisher
//        }
//    }
}
