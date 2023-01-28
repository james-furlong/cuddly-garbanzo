//
//  LoginViewState.swift
//  Dexcom Monitor
//
//  Created by James on 22/1/2023.
//

import Foundation

enum LoginViewState: Hashable {
    case start
    case clientName
    case userName
    case login
    case complete(Bool)
    
    var title: String {
        switch self {
            case .start: return "Get started"
            case .clientName: return "Your name"
            case .userName: return "Their name"
            case .login: return "Login"
            case .complete(let isSuccess): return isSuccess ? "Success" : "Error"
        }
    }
    
    var subtitle: String {
        switch self {
            case .start: return "We just need to get a few details from you"
            case .clientName: return "What would you like us to call you?"
            case .userName: return "What is the name of the person you're following?"
            case .login: return "We just need you to log into your follow account"
            case .complete(let isSuccess): return isSuccess ? "Let's head to your dashboard" : "Something went wrong, try again later"
        }
    }
    
    var submitTitle: String {
        switch self {
            case .clientName, .userName: return "Next"
            case .login: return "Login"
            default: return ""
        }
    }
    
    var hideTextField: Bool {
        switch self {
            case .start, .login, .complete: return true
            default: return false
        }
    }
    
    var imageName: String {
        switch self {
            case .complete(let isSuccess): return isSuccess ? "arrow.right" : "arrow.left"
            default: return "arrow.right"
        }
    }
    
    var nextState: LoginViewState {
        switch self {
            case .start: return .clientName
            case .clientName: return .userName
            case .userName: return .login
            case .login: return .complete(true)
            default: return .start
        }
    }
}
