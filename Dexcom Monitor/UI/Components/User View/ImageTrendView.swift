//
//  ImageTrendView.swift
//  Dexcom Monitor
//
//  Created by James on 20/12/2022.
//

import SwiftUI

struct ImageTrendView: View {
    let imageUrl: String
    let trend: Trend
    
    var body: some View {
        VStack {
            ZStack {
                // Image
                Image(imageUrl)
                    .clipShape(Circle())
                
                // Background
                Circle()
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 10
                    )
                
                // Trending
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(
                        trend.trendColor.opacity(0.7),
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(trend.rotation))
                
                // Urgent
                Circle()
                    .trim(from: 0.05, to: 0.20)
                    .stroke(
                        trend.urgentColor.opacity(0.8),
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(trend.rotation))
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct ImageTrendView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTrendView(imageUrl: "", trend: .stable)
    }
}
