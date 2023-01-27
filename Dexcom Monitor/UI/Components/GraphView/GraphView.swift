//
//  GraphView.swift
//  Dexcom Monitor
//
//  Created by James on 26/12/2022.
//

import SwiftUI

struct GraphView: View {
    @State var chartData: [LineChartData]
    
    @State var name: String = "Name"
    @State var rangePercentage: Double = 100.0
    @State var bgl: Double = 100.0
    
    let background = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("Blood Glucose")
                        .font(.system(size: 12).bold())
                        .foregroundColor(Color("FontMain"))
                    
                    Spacer()
                    
                    Text("Average this week")
                        .font(.system(size: 10))
                        .foregroundColor(Color("FontMain").opacity(0.6))
                    
                    Text("120mg/dl")
                        .font(.system(size: 12).bold())
                        .foregroundColor(Color("FontMain"))
                }
                .padding()
                
                LineChart(data: chartData).padding()
            }
            .background(Color("AccentColor"))
            .cornerRadius(30)
            .padding()
            .shadow(radius: 10, x: 5, y: 5)
        }
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(chartData: [])
    }
}
