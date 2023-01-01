//
//  Result+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 31/12/2022.
//

import Foundation

// Note: The 'public' is needed so we can use these in tests
public extension Result {
    func successOrNull() -> Success? {
        switch self {
            case .success(let result): return result
            default: return nil
        }
    }
    
    func failureOrNull() -> Error? {
        switch self {
            case .failure(let error): return error
            default: return nil
        }
    }

    func defaulting(to value: Success) -> Success {
        switch self {
            case .success(let result): return result
            default: return value
        }
    }
}
