//
//  InfoType.swift
//  Dexcom Monitor
//
//  Created by James on 26/12/2022.
//

import SwiftUI

enum InfoType {
    case glucose
    case pills
    case activity
    case carbs
    
    var name: String {
        switch self {
            case .glucose: return "Glucose"
            case .pills: return "Pills"
            case .activity: return "Activity"
            case .carbs: return "Carbs"
        }
    }
    
    var valueSubtext: String {
        switch self {
            case .glucose: return "mg/dl"
            case .pills: return "taken"
            case .activity: return "steps"
            case .carbs: return "cal"
        }
    }
    
    var imageName: String {
        switch self {
            case .glucose: return "drop.fill"
            case .pills: return "pill.fill"
            case .activity: return "figure.walk"
            case .carbs: return "carrot.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
            case .glucose: return .red
            case.pills: return .yellow
            case .activity: return .green
            case .carbs: return .orange
        }
    }
}
