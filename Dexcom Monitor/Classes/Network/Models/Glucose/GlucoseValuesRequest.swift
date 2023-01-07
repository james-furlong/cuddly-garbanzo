//
//  GlucoseValuesRequest.swift
//  Dexcom Monitor
//
//  Created by James on 7/1/2023.
//

import Foundation

struct GlucoseValuesRequest: Codable {
    let startDateTime: Date
    let endDateTime: Date
}
