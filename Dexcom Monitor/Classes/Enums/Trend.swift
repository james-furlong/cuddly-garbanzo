//
//  Trend.swift
//  Dexcom Monitor
//
//  Created by James on 20/12/2022.
//

import SwiftUI

enum Trend {
    case rapidlyDecreasing
    case decreasing
    case stable
    case increasing
    case rapidlyIncreasing
    
    var trendColor: Color {
        switch self {
            case .rapidlyDecreasing, .decreasing: return .red
            case .stable: return .green
            case .increasing, .rapidlyIncreasing: return .yellow
        }
    }
    
    var urgentColor: Color {
        switch self {
            case .rapidlyDecreasing: return .red
            case .rapidlyIncreasing: return .yellow
            default: return .clear
        }
    }
    
    var rotation: Double {
        switch self {
            case .rapidlyDecreasing: return 45
            case .decreasing: return 0
            case .stable: return -45
            case .increasing: return -90
            case .rapidlyIncreasing: return -135
        }
    }
}
