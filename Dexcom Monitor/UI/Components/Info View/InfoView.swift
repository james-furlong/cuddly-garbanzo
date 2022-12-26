//
//  InfoView.swift
//  Dexcom Monitor
//
//  Created by James on 26/12/2022.
//

import SwiftUI

struct InfoView: View {
    let type: InfoType
    let amount: Double
    let background = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(type.name)")
                    .font(.system(size: 17).weight(.bold))
                    .foregroundColor(Color("FontMain"))
                
                HStack(alignment: .bottom) {
                    Text(String(format: type == .glucose ? "%.1f" : "%.0f", amount))
                        .font(.system(size: 15).bold())
                        .foregroundColor(Color("FontMain"))
                    Text("\(type.valueSubtext)")
                        .font(.system(size: 10))
                        .foregroundColor(Color("FontMain"))
                    Spacer()
                }
            }
            .padding()
            
            Image(systemName: type.imageName)
                .font(.system(size: 40))
                .foregroundColor(type.imageColor)
                .padding()
            
        }
        .frame(height: 100)
        .background(Color("AccentColor"))
        .cornerRadius(30)
        .shadow(radius: 15)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(type: .glucose, amount: 20)
    }
}
