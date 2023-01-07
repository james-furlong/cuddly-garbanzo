//
//  LineChart.swift
//  Dexcom Monitor
//
//  Created by James on 26/12/2022.
//

import SwiftUI
import Charts

struct LineChartData: Hashable {
    let dateTime: Date
    let bgl: Double
}

struct LineChart: View {
    let date = Date()
    let data: [LineChartData] = [
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-5 * 60)), bgl: 10.5),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-10 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-15 * 60)), bgl: 9.5),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-20 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-25 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-30 * 60)), bgl: 12.5),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-35 * 60)), bgl: 10.5),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-40 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-45 * 60)), bgl: 9.5),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-50 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-55 * 60)), bgl: 10.0),
        LineChartData(dateTime: Date().addingTimeInterval(TimeInterval(-60 * 60)), bgl: 12.5)
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Chart {
                ForEach(data, id: \.self) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.dateTime),
                        y: .value("BGL", dataPoint.bgl)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.cyan)
                    .lineStyle(StrokeStyle(lineWidth: 1.5))
                    .symbol() {
                        Circle()
                            .fill(.cyan)
                            .frame(width: 8, height: 8)
                    }
                    .symbolSize(30)
                }
            }
            .chartYAxis() {
                AxisMarks(position: .leading) {
                    AxisValueLabel().foregroundStyle(Color("FontMain"))
                }
            }
            .chartXAxis() {
                AxisMarks(position: .bottom) {
                    AxisValueLabel(centered: true).foregroundStyle(Color("FontMain"))
                }
            }
            .frame(height: 200)
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart()
    }
}
