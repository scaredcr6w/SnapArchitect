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
        let windowLocation = event.locationInWindow
        let localFrame = geo.frame(in: .local)
        let windowWidth = NSScreen.main?.frame.width ?? 0
        let geoWidth = localFrame.width
        let xOffset = (windowWidth - geoWidth) / 2
        let convertedLocation = CGPoint(x: windowLocation.x - xOffset, y: geo.size.height - windowLocation.y)
        return convertedLocation
    }
}
