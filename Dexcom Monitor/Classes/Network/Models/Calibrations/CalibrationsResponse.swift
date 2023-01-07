//
//  CalibrationsResponse.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

struct CalibrationsResponse: Codable {
    let calibrations: [Calibration]
}

struct Calibration: Codable {
    let systemTime: Date
    let displayTime: Date
    let unit: Unit
    let value: Double
}
