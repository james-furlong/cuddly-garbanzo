//
//  AnimationCompletionObservableModifier.swift
//  Dexcom Monitor
//
//  Created by James on 22/1/2023.
//

import SwiftUI

struct AnimationCompletionObservable<Value>: AnimatableModifier where Value: VectorArithmetic {
    private var targetValue: Value
    private var completion: () -> Void
    
    var animatableData: Value {
        didSet {
            notifyCompletionFinished()
        }
    }
    
    // MARK: - Initialization
    
    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.targetValue = observedValue
        self.animatableData = observedValue
    }
    
    private func notifyCompletionFinished() {
        guard animatableData == targetValue else { return }
        
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    func body(content: Content) -> some View {
        return content
    }
}
