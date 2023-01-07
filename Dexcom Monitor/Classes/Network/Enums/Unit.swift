//
//  Unit.swift
//  Dexcom Monitor
//
//  Created by James on 8/1/2023.
//

import Foundation

enum Unit: String, Codable {
    case milligramsDecilitre = "mg/dL"
    case milligramsDecilitreMinute = "mg/dL/min"
    case millimolesLitre = "mmol/L"
    case millimolesLitreMinute = "mmol/L/min"
    
    case grams
    case units
    case minutes
}
