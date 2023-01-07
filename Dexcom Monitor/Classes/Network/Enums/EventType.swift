//
//  EventType.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

enum EventType: Codable {
    case carbs
    case insulin
    case exercise
    case health
}

enum EventSubType: Codable {
    case fastActing
    case longActing
    case light
    case medium
    case heavy
    case illness
    case stress
    case highSymptoms
    case lowSymptoms
    case cycle
    case alcohol
}
