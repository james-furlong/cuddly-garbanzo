//
//  LoginViewModel.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import Foundation
import AuthenticationServices
import Combine

class LoginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    private let api = DexcomAPI()
    private var subscriptions = Set<AnyCancellable>()
    
    private let clientId: String = "q7QlbWrpLBWNxsoNqqcHTxmMIYyPJYZe"
    private let clientSecret: String = "ssSn2oayJVGHvnPJ"
    private let redirctUri: String = "monitor"

    // MARK: - ASWebAuthenticationPresentationContextProviding

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    // MARK: - Subjects
    
    let authTokenSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    let authCompleteSubject: PassthroughSubject<Bool, Never> = PassthroughSubject()
    let errorSubject: CurrentValueSubject<Error?, Never> = CurrentValueSubject(nil)

    var webSession: ASWebAuthenticationSession?

    func signIn() {
        guard var url = URL(string: "https://sandbox-api.dexcom.com/v2/oauth2/login") else { return }
        url.append(queryItems: [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: "monitor://"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "offline_access")
        ])

        webSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: redirctUri
        ) { [weak self] url, error in
            guard error == nil, let successUrl = url else {
                return
            }

            // TODO: Extract and save token
            let parameters: [String: String] = successUrl.queryParameters ?? [:]
            let authorizationCode: String = parameters["code"] ?? ""
            self?.retrieveAuthTokens(authorizationCode)
        }

        webSession?.presentationContextProvider = self
        webSession?.prefersEphemeralWebBrowserSession = true
        webSession?.start()
    }
    
    func retrieveAuthTokens(_ code: String) {
        api.verifyAuthorization(token: code)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                        case .failure(let error): self?.errorSubject.send(error)
                        case .finished: return
                    }
                },
                receiveValue: { [weak self] response in
                    self?.authCompleteSubject.send(true)
                }
            )
            .store(in: &subscriptions)
    }
}
