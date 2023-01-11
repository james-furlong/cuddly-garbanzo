//
//  DashboardViewModel.swift
//  Dexcom Monitor
//
//  Created by James on 9/1/2023.
//

import Foundation
import Combine

extension DashboardView {
    @MainActor class DashboardViewModel: ObservableObject {
        
        private var subscriptions: Set<AnyCancellable> = Set()
     
        // MARK: - Publishers
        
        @Published var timeframe: Int = 3
        
        // MARK: - Endpoint responses
        
        var glucoseValuesResponse: AnyPublisher<Result<GlucoseValuesResponse, Error>, Never> {
            $timeframe
                .flatMap { timeframe in
                    Injector.apiClient.getGlucoseValues(
                        query: QueryRequest(
                            startDate: Calendar.current.date(byAdding: .hour, value: -timeframe, to: Date()) ?? Date(),
                            endDate: Date()
                        )
                    )
                }
                .eraseToAnyPublisher()
                .asResult()
        }
        
        // MARK: - Values
        
        var username: AnyPublisher<String, Never> {
            Just(())
                .map { _ in
                    Injector.cache.string(forKey: Constants.CachedDataKey.username) ?? ""
                }
                .eraseToAnyPublisher()
        }
        
        var date: AnyPublisher<String, Never> {
            Just(())
                .map { _ in
                    let formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "E, dd MMM"
                    return formatter.string(from: Date())
                }
                .eraseToAnyPublisher()
        }
        
        var glucoseValues: AnyPublisher<[LineChartData], Never> {
            glucoseValuesResponse
                .filterToSuccess()
                .map { (data: GlucoseValuesResponse) -> [LineChartData] in
                    data.egvs.map { egvs -> LineChartData in
                        LineChartData(
                            dateTime: egvs.displayTime,
                            value: egvs.value,
                            unit: data.unit
                        )
                    }
                }
                .eraseToAnyPublisher()
        }
        
    }
}
