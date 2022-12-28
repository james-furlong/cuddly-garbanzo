//
//  UserView.swift
//  Dexcom Monitor
//
//  Created by James on 19/12/2022.
//

import SwiftUI

struct UserView: View {
    @State var name: String = "Name"
    @State var rangePercentage: Double = 100.0
    @State var bgl: Double = 100.0
    
    let background = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("\(name)")
                        .font(.title.bold())
                        .foregroundColor(Color("FontMain"))
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text(String(format: "%.0f time in range", rangePercentage))
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text(String(format: "%.1f", bgl))
                        .font(.caption2)
                        .foregroundColor(Color("FontMain"))
                        .background(.black.opacity(0.10))
                        .clipShape(Capsule())
                        .frame(alignment: .leading)
                }
                .padding()
            }
            .padding()
            
            Spacer()
            Spacer()
            Spacer()
            
            ImageTrendView(imageUrl: "", trend: .increasing)
            
            Spacer()
        }
        .frame(height: 150)
        .background(Color("AccentColor"))
        .cornerRadius(30)
        .padding()
        .shadow(radius: 10)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
