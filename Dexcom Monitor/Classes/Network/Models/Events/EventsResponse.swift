//
//  EventsResponse.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

struct EventsResponse: Codable {
    let events: [Event]
}

struct Event: Codable {
    let eventId: String
    let systemTime: Date
    let displayTime: Date
    let eventType: EventType
    let eventSubType: EventSubType?
    let value: Double?
    let unit: Unit?
    let eventStatus: EventStatus
}
