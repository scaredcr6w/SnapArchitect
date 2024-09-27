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
    
    /// Calculates distance between two points
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: The distance between the points in CGFloat
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        
        return sqrt(pow(xDist, 2) + pow(yDist, 2))
    }
    
    /// Finds the closest element from an array of OOPElementRepresentations to the location of the point
    /// - Parameters:
    ///   - location: the location of the point
    ///   - elements: an array containing OOPElementRepresentations
    /// - Returns: OOPElementRepresentation that is closest to the point
    func findClosestElement(to location: CGPoint, _ elements: [OOPElementRepresentation]) -> OOPElementRepresentation? {
        guard let firstElement = elements.first else { return nil }
        
        var closestElement = firstElement
        var closestDistance = distance(from: firstElement.position, to: location)
        
        for element in elements {
            let currentDistance = distance(from: element.position, to: location)
            if currentDistance < closestDistance {
                closestElement = element
                closestDistance = currentDistance
            }
        }
        return closestElement
    }
    
    /// Checks if a connection between two OOPElementRepresentations exists
    /// - Parameters:
    ///   - startElement: an OOPElementRepresentation
    ///   - endElement: an OOPElementRepresentation
    ///   - connections: an array containing OOPConnectionRepresentations
    /// - Returns: whether there is or isn't a connection between the given elements
    func checkIfConnectionExists(
        _ startElement: OOPElementRepresentation,
        _ endElement: OOPElementRepresentation,
        _ connections: [OOPConnectionRepresentation]
    ) -> Bool {
        if connections.contains(where: { $0.startElement == startElement && $0.endElement == endElement }) {
            return true
        } else if connections.contains(where: { $0.startElement == endElement && $0.endElement == startElement }) {
            return true
        } else {
            return false
        }
    }
    
    /// Creates a connection between two OOPElementRepresentations
    /// - Parameters:
    ///   - start: the point, from which the closest element is being determinted. This will be used as the connection's start element.
    ///   - prededictedEnd: the point, from which the closest element is being determinted. This will be used as the connection's end element.
    ///   - location: the point of the Drag gesture's current point, that is used to find the closest end element more accurately
    ///   - elements: an array containing OOPElementRepresentations
    ///   - connections: an array containing OOPConnectionRepresentations
    /// - Returns: a new OOPConnectionRepresentation between two elements
    func createConnection(
        from start: CGPoint,
        to prededictedEnd: CGPoint,
        location: CGPoint,
        connectionType: OOPConnectionType,
        elements: [OOPElementRepresentation],
        connections: [OOPConnectionRepresentation]
    ) -> OOPConnectionRepresentation? {
        guard !elements.isEmpty else { return nil }
        guard distance(from: prededictedEnd, to: location) <= 10 else { return nil }
        guard let startElement = findClosestElement(to: start, elements) else { return nil }
        guard let endElement = findClosestElement(to: location, elements) else { return nil }
        if checkIfConnectionExists(startElement, endElement, connections) { return nil }
        
        return OOPConnectionRepresentation(type: connectionType, startElement: startElement, endElement: endElement)
    }
}
