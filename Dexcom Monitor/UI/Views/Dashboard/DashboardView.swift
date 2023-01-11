//
//  DashboardView.swift
//  Dexcom Monitor
//
//  Created by James on 19/12/2022.
//

import SwiftUI
import Combine

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel = DashboardViewModel()
    
    @State private var userName: String = ""
    @State private var date: String = ""
    @State private var chartData: [LineChartData] = []
    
    private var subscriptions: Set<AnyCancellable> = Set()
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 30)
            HStack {
                VStack {
                    Text("Hi, \(userName)!")
                        .font(.title.bold())
                        .foregroundColor(Color("FontMain"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onReceive(viewModel.username) { userName = $0 }
                    
                    Text("\(date)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("FontMain").opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onReceive(viewModel.date) { date = $0 }
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            UserView()
            
            VStack {
                HStack {
                    InfoView(type: .glucose, amount: 5.4)
                    InfoView(type: .pills, amount: 2.0)
                }
                
                HStack {
                    InfoView(type: .activity, amount: 100.0)
                    InfoView(type: .carbs, amount: 300)
                }
            }
            .padding()
            
            GraphView(chartData: chartData)
                .onReceive(viewModel.glucoseValues) { chartData = $0 }
            
            Spacer()
        }
        .background(RadialGradient(
            colors: [Color("BackgroundMain"), Color("BackgroundSupp")],
            center: .center,
            startRadius: 1,
            endRadius: 700
        ).edgesIgnoringSafeArea(.all))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
