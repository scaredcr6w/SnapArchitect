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
    
    func updateScrollOffsets(geo: GeometryProxy) {
        xScrollOffset = geo.frame(in: .global).minX
        yScrollOffset = geo.frame(in: .global).minY
    }
    
    func getMouseClick(_ geo: GeometryProxy, event: NSEvent) -> CGPoint {
        let windowLocation = event.locationInWindow
        let clickPosition = CGPoint(
            x: (windowLocation.x - xScrollOffset),
            y: (geo.size.height - windowLocation.y - yScrollOffset)
        )
        return clickPosition
    }
    
    func newElement(_ geo: GeometryProxy, _ selectedTool: OOPElementType?) -> OOPElementRepresentation? {
        guard let event = NSApp.currentEvent, let type = selectedTool else { return nil }
        let clickLocation = getMouseClick(geo, event: event)
        return .init(.accessPublic, type.rawValue, type, clickLocation, CGSize(width: 100, height: 100))
    }
    
    func getEdgeCenters(
        elementPosition: CGPoint,
        elementSize: CGSize
    ) -> (top: CGPoint, bottom: CGPoint, leading: CGPoint, trailing: CGPoint) {
        let leadingEdgeCenter = CGPoint(
            x: elementPosition.x - elementSize.width / 2,
            y: elementPosition.y
        )
        let trailingEdgeCenter = CGPoint(
            x: elementPosition.x + elementSize.width / 2,
            y: elementPosition.y
        )
        let topEdgeCenter = CGPoint(
            x: elementPosition.x,
            y: elementPosition.y - elementSize.height / 2
        )
        let bottomEdgeCenter = CGPoint(
            x: elementPosition.x,
            y: elementPosition.y + elementSize.height / 2
        )
        
        return (
            top: topEdgeCenter,
            bottom: bottomEdgeCenter,
            leading: leadingEdgeCenter,
            trailing: trailingEdgeCenter
        )
    }
    
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        
        return sqrt(pow(xDist, 2) + pow(yDist, 2))
    }
    
    func findClosestElement(to dragEndPos: CGPoint, _ elements: [OOPElementRepresentation]) -> OOPElementRepresentation? {
        guard let firstElement = elements.first else { return nil }
        
        var closestElement = firstElement
        var closestDistance = distance(from: firstElement.position, to: dragEndPos)
        
        for element in elements {
            let currentDistance = distance(from: element.position, to: dragEndPos)
            if currentDistance < closestDistance {
                closestElement = element
                closestDistance = currentDistance
            }
        }
        return closestElement
    }
}
