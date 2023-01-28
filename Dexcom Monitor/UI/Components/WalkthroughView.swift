//
//  WalkthroughView.swift
//  Dexcom Monitor
//
//  Created by James on 28/1/2023.
//

import SwiftUI

struct WalkthroughView: View {
    
    let cell: WalkthroughCell
    
    // MARK: Initialization
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                cell.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .padding(.top, 15)
                
                Spacer()
                
                Text(cell.title)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Font"))
                    .padding()
                    .padding(.bottom, 10)
            }
        }
    }
}

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughView(cell: .insights)
    }
}
