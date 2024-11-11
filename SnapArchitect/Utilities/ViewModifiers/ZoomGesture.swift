//
//  ZoomGesture.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 05..
//

import SwiftUI
import AppKit

import SwiftUI

struct ZoomGesture: ViewModifier {
    @ObservedObject var zoomManager: ZoomManager
    var geometrySize: CGSize

    func body(content: Content) -> some View {
        content
            .scaleEffect(zoomManager.currentScale)
            .offset(zoomManager.currentOffset)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / zoomManager.lastScale
                            zoomManager.lastScale = value
                            var newScale = zoomManager.currentScale * delta
                            newScale = min(max(newScale, zoomManager.minScale), zoomManager.maxScale)
                            
                            // Calculate the adjustment for the offset based on mouse position
                            let cursorPosition = zoomManager.mouseLocation
                            let adjustedOffset = CGSize(
                                width: (cursorPosition.x - geometrySize.width / 2) * (1 - delta),
                                height: (cursorPosition.y - geometrySize.height / 2) * (1 - delta)
                            )
                            zoomManager.currentOffset.width += adjustedOffset.width
                            zoomManager.currentOffset.height += adjustedOffset.height
                            
                            zoomManager.currentScale = newScale
                        }
                        .onEnded { _ in
                            zoomManager.lastScale = 1.0
                        },
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            zoomManager.mouseLocation = value.location
                        }
                )
            )
    }
}
