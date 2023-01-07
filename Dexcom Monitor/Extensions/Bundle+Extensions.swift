//
//  Bundle+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

extension Bundle {
    public static var appVersion: String? {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }
    
    public static var appTarget: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
    }
}
