//
//  Optional+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

extension Optional {
    public func defaulting(to value: Wrapped) -> Wrapped {
        return (self ?? value)
    }
}

public extension Optional where Wrapped == String {
    var isNullOrEmpty: Bool {
        return (
            self == nil ||
            self?.isEmpty == true
        )
    }
}
