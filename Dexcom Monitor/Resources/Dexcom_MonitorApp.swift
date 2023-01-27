//
//  Dexcom_MonitorApp.swift
//  Dexcom Monitor
//
//  Created by James on 19/12/2022.
//

import SwiftUI

@main
struct Dexcom_MonitorApp: App {
    let initialView: any View
    
    init() {
        Injector.log.logLevel = .verbose
        initialView = Injector.cache.contains(key: Constants.KeychainDataKey.authToken) ? DashboardView() : LoginView()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
