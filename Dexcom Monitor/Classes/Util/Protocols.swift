//
//  Protocols.swift
//  Dexcom Monitor
//
//  Created by James on 22/1/2023.
//

import Foundation
import Combine

protocol Api {
    var clientId: String { get }
    var clientSecret: String { get }
    var redirectUri: String { get }
    
    func verifyAuthorization(token: String) -> AnyPublisher<AuthTokenResponse, Error>
}
