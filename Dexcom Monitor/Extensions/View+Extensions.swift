//
//  View+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 12/1/2023.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObservable<Value>> {
        return modifier(AnimationCompletionObservable(observedValue: value, completion: completion))
    }
}
