//
//  Constants.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

struct Constants {
    enum CachedDataKey: String, CaseIterable, Storable {
        case refreshDateTime = "feb138bf-3b97-4c3d-969f-dca28fe67bab"
        case username = "e7b31c55-aa5e-4326-bee2-03bbb803b6d2"
        case followeeName = "53b6e44c-1ba8-4a28-ad81-1d4150835087"
        
        var isSensitive: Bool {
            return false
        }
    }

    enum KeychainDataKey: String, CaseIterable, Storable {
        case authToken = "839b7be6-efe3-4524-877c-555921f3d3f2"
        case refreshToken = "92400100-17f1-4544-9977-4e7dad32ccc2"
        case tokenExpiry = "4ab9d5e5-46a7-4da1-a28f-c1b36e4c45a2"
        
        var isSensitive: Bool {
            return true
        }
    }
    
    enum Application: String {
        // Note: These values are used before the authClient is setup so go direct to
        // shared prefs
        case targetKey = "TargetEnv"
        case targetAppKey = "TargetApp"
    }
}

protocol Storable {
    var isSensitive: Bool { get }
    var rawValue: String { get }
}
