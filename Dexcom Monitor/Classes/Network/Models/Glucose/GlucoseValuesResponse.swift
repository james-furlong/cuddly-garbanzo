//
//  GlucoseValuesResponse.swift
//  Dexcom Monitor
//
//  Created by James on 7/1/2023.
//

import Foundation

struct GlucoseValuesResponse: Codable {
    let unit: String
    let rateUnit: String
    let egvs: [Egvs]
}

struct Egvs: Codable {
    let systemTime: Date
    let displayTime: Date
    let value: Int
    let realtimeValue: Int
    let smoothedValue: Int
    let status: EgvsStatus?
    let trend: EgvsTrend?
    let trendRate: Double
}

enum EgvsStatus: Codable {
    case low
    case high
}

enum EgvsTrend: String, Codable {
    case doubleUp
    case singleUp
    case fortyFiveUp
    case flat
    case fortyFiveDown
    case singleDown
    case doubleDown
    case noTrend = "none"
    case notComputable
    case rateOutOfRange
}
