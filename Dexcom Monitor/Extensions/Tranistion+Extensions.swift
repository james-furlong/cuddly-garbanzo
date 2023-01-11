//
//  Tranistion+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 11/1/2023.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
