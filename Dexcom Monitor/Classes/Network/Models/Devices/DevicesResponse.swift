//
//  DevicesResponse.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

struct DevicesResponse: Codable {
    let devices: [Device]
}

struct Device: Codable {
    let transmitterGeneration: String?
    let displayDevice: String?
    let lastUploadDate: Date
    let alertScheduleList: [DexcomAlert]
}

struct DexcomAlert: Codable {
    let alertScheduleSettings: ScheduleSettings
    let slertSettings: [AlertSettings]
}

struct ScheduleSettings: Codable {
    let alertScheduleName: String
    let isEnabled: Bool
    let isDefaultSchedule: Bool
    let startTime: Date
    let endTime: Date
    let daysOfWeek: [String]
}

struct AlertSettings: Codable {
    let alertName: Alert
    let value: Double?
    let snooze: Double?
    let enabled: Bool
    let systemTime: Date
    let displayTime: Date
}
