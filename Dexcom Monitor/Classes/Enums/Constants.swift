//
//  Constants.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

struct Constants {
//    enum CachedUserDataKey: String, CaseIterable, Storable {
//        
//        
//        var shouldStoreEncrypted: Bool {
//            return true
//        }
//
//        var shouldSurviveAppDeletion: Bool {
//            return false
//        }
//    }
//
//    enum Keychain: String, CaseIterable, Storable {
//        var shouldStoreEncrypted: Bool {
//            return true
//        }
//
//        var shouldSurviveAppDeletion: Bool {
//            return false
//        }
//    }
    
    enum Application: String {
        // Note: These values are used before the authClient is setup so go direct to
        // shared prefs
        case targetKey = "TargetEnv"
        case targetAppKey = "TargetApp"
    }
}

protocol Storable {
    var shouldStoreEncrypted: Bool { get }
    var shouldSurviveAppDeletion: Bool { get }
    var rawValue: String { get }
}
