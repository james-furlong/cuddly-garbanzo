//
//  DataRangeResponse.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

struct DataRangeResponse: Codable {
    let calibrations: DataRange
    let egvs: DataRange
    let events: DataRange
}

struct DataRange: Codable {
    let start: DateTime
    let end: DateTime
}

struct DateTime: Codable {
    let systemTime: Date
    let displayTime: Date
}
