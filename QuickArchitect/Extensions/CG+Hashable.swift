//
//  CGPoint+Hashable.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation
import SwiftUI

extension CGPoint: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGSize: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
