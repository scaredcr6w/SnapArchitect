//
//  CanvasViewModel.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation
import SwiftUI

final class CanvasViewModel: ObservableObject {
    func getMouseClick(_ geo: GeometryProxy, event: NSEvent) -> CGPoint {
        let windowlocation = event.locationInWindow
        let clickPosition = CGPoint(x: windowlocation.x, y: geo.size.height - windowlocation.y)
        return clickPosition
    }
}
