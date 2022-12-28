//
//  AnalyticsView.swift
//  Dexcom Monitor
//
//  Created by James on 27/12/2022.
//

import SwiftUI

struct AnalyticsView: View {
    
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 30)
            
        }
        .frame(width: .infinity, height: .infinity)
        .background(RadialGradient(
            colors: [Color("BackgroundMain"), Color("BackgroundSupp")],
            center: .center,
            startRadius: 1,
            endRadius: 700
        ).edgesIgnoringSafeArea(.all))
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
