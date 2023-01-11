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
    let value: Double
    let unit: Unit
}

struct LineChart: View {
    let date = Date()
    let data: [LineChartData]
    
    var body: some View {
        VStack(spacing: 30) {
            Chart {
                ForEach(data, id: \.self) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.dateTime),
                        y: .value(dataPoint.unit.rawValue, dataPoint.value)
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
        LineChart(data: [LineChartData]())
    }
}
