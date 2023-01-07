//
//  Alert.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

enum Alert: Codable {
    case high
    case low
    case rise
    case fall
    case urgentLow
    case urgentLowSoon
    case outOfRange
    case noReadings
}
