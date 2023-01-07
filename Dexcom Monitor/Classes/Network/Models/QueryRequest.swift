//
//  QueryRequest.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

struct QueryRequest: Codable {
    let startDate: Date
    let endDate: Date
    
    var query: String {
        return "startDate=\(startDate)&endDate=\(endDate)"
    }
}
