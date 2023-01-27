//
//  LoginDetailModel.swift
//  Dexcom Monitor
//
//  Created by James on 22/1/2023.
//

import Foundation

class LoginDetailModel {
    var clientName: String
    var userName: String
        
    init(clientName: String = "", userName: String = "") {
        self.clientName = clientName
        self.userName = userName
    }
    
    func update(with input: String, for state: LoginViewState) {
        switch state {
            case .clientName: clientName = input
            case .userName: userName = input
            default: break
        }
    }
}
