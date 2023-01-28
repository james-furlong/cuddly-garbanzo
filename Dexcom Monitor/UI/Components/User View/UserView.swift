//
//  UserView.swift
//  Dexcom Monitor
//
//  Created by James on 19/12/2022.
//

import SwiftUI

struct UserView: View {
    @State var name: String? = Injector.cache.string(forKey: Constants.CachedDataKey.followeeName)
    @State var rangePercentage: Double? = 100.0
    @State var bgl: Double? = 100.0
    
    let background = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(name ?? "")
                        .font(.title.bold())
                        .foregroundColor(Color("Font"))
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text(String(format: "%.0f time in range", rangePercentage ?? 0))
                        .font(.subheadline)
                        .foregroundColor(Color("FontSupp"))
                        .isHidden(rangePercentage == nil)
                    
                    Text(String(format: "%.1f", bgl ?? 0))
                        .font(.caption2)
                        .foregroundColor(Color("Font"))
                        .padding(7)
                        .background(.black.opacity(0.10))
                        .clipShape(Capsule())
                        .frame(alignment: .leading)
                        .isHidden(bgl == nil)
                }
                .padding()
            }
            .padding()
            
            Spacer()
            Spacer()
            Spacer()
            
            ImageTrendView(imageUrl: "", trend: .stable)
            
            Spacer()
        }
        .frame(height: 150)
        .background(Color("BackgroundSupp"))
        .cornerRadius(30)
        .padding()
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
