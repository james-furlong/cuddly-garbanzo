//
//  ContentView.swift
//  Dexcom Monitor
//
//  Created by James on 28/1/2023.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = Injector.cache.contains(key: Constants.KeychainDataKey.authToken)
    
    var body: some View {
        if isLoggedIn {
            DashboardView()
        }
        else {
            OnboardingView { isLoggedIn = true }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
