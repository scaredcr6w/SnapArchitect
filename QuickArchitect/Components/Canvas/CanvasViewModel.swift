//
//  CanvasViewModel.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation
import SwiftUI

final class CanvasViewModel: ObservableObject {
    @Published var xScrollOffset: CGFloat = 0
    @Published var yScrollOffset: CGFloat = 0
    
    func getMouseClick(_ geo: GeometryProxy, event: NSEvent) -> CGPoint {
        let windowLocation = event.locationInWindow
        let clickPosition = CGPoint(
            x: (windowLocation.x - xScrollOffset),
            y: (geo.size.height - windowLocation.y - yScrollOffset)
        )
        return clickPosition
    }
}
