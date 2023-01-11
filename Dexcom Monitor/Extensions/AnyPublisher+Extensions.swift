//
//  AnyPublisher+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 10/1/2023.
//

import Foundation
import Combine

extension AnyPublisher {
    func asResult() -> AnyPublisher<Result<Output, Error>, Never> {
        self
            .map(Result.success)
            .catch { error in
                Just(Result.failure(error))
            }
            .eraseToAnyPublisher()
    }
    
    func filterToSuccess<T>() -> AnyPublisher<T, Never> where Self.Output == Result<T, Error> {
        self
            .map { result -> (T?, Bool) in
                switch result {
                    case .success(let data): return (data, true)
                    case .failure: return (nil, false)
                }
            }
            .filter { $0.1 }
            .map { $0.0! }
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
}
