//
//  WalkthroughCell.swift
//  Dexcom Monitor
//
//  Created by James on 28/1/2023.
//

import Foundation
import SwiftUI

enum WalkthroughCell {
    case insights
    case multipleAccounts
    
    var title: String {
        switch self {
            case .insights: return "Get insights into glucose levels"
            case .multipleAccounts: return "Monitor multiple accounts"
        }
    }
    
    var buttonText: String {
        switch self {
            case .insights: return "Next"
            case .multipleAccounts: return "Login"
        }
    }
    
    var image: Image {
        switch self {
            case .insights: return Image("placeholder")
            case .multipleAccounts: return Image("placeholder")
        }
    }
    
    var next: WalkthroughCell {
        switch self {
            case .insights: return .multipleAccounts
            case .multipleAccounts: return .multipleAccounts
        }
    }
    
    var prev: WalkthroughCell {
        switch self {
            case .insights: return .insights
            case .multipleAccounts: return .insights
        }
    }
    
    var backButtonIsHidden: Bool {
        switch self {
            case .insights: return true
            default: return false
        }
    }
}
