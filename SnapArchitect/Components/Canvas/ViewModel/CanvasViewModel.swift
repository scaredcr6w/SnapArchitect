//
//  CanvasViewModel.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation
import SwiftUI

final class CanvasViewModel: ObservableObject {
    // MARK: Properties
    @AppStorage("canvasBackgorundColor") var backgroundColor: Color = .white
    @AppStorage("showGrid") var showGrid: Bool = false
    @AppStorage("snapToGrid") var snapToGrid: Bool = false
    @AppStorage("gridSize") var gridSize: Double = 10
    
    @Published var document: SnapArchitectDocument
    @Published var xScrollOffset: CGFloat = 0
    @Published var yScrollOffset: CGFloat = 0
    
    @Published var selectionRect: CGRect = .zero
    @Published var dragStartLocation: CGPoint? = nil
    @Published var isDraging: Bool = false
    
    init(document: SnapArchitectDocument) {
        self.document = document
        NotificationCenter.default.addObserver(self, selector: #selector(handleDocumentChange), name: .documentDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .documentDidChange, object: nil)
    }
    
    @objc private func handleDocumentChange() {
        objectWillChange.send()
    }
    
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
    
    /// Creates a new OOPElementrRepresentation and adds it to the document
    /// - Parameters:
    ///   - geo: the geometry of the CanvasView
    ///   - selectedTool: type of the desired element
    func newElement(
        at geo: GeometryProxy,
        _ selectedTool: Any?
    ) {
        guard let event = NSApp.currentEvent, let selectedTool = selectedTool as? OOPElementType else { return }
        let clickLocation = getMouseClick(geo, event: event)
        let element = OOPElementRepresentation(.accessPublic, selectedTool.rawValue, selectedTool, clickLocation, CGSize(width: 100, height: 100))
        
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            document.diagrams[diagramIndex].entityRepresentations.append(element)
            ToolManager.shared.selectedTool = nil
        }
    }
    
    /// Creates a connection between two OOPElementRepresentations
    /// - Parameters:
    ///   - start: the point, from which the closest element is being determinted. This will be used as the connection's start element.
    ///   - prededictedEnd: the point, from which the closest element is being determinted. This will be used as the connection's end element.
    ///   - location: the point of the Drag gesture's current point, that is used to find the closest end element more accurately
    /// - Returns: a new OOPConnectionRepresentation between two elements
    func newConnection(
        from start: CGPoint,
        to prededictedEnd: CGPoint,
        location: CGPoint
    ) {
        guard let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        guard let selectedTool = ToolManager.shared.selectedTool as? OOPConnectionType else { return }
        
        let elements = document.diagrams[diagramIndex].entityRepresentations
        
        guard !elements.isEmpty else { return }
        guard distance(from: prededictedEnd, to: location) <= 10 else { return }
        guard let startElement = findClosestElement(to: start, elements) else { return }
        guard let endElement = findClosestElement(to: location, elements) else { return }
        if checkIfConnectionExists(startElement, endElement) { return }
        
        document.diagrams[diagramIndex].entityConnections.append(
            .init(
                type: selectedTool,
                startElement: startElement,
                endElement: endElement
            )
        )
        ToolManager.shared.selectedTool = nil
    }
    
    func snapToGrid(_ point: CGPoint, gridSize: Double) -> CGPoint {
        let snappedX = round(point.x / gridSize) * gridSize
        let snappedY = round(point.y / gridSize) * gridSize
        return CGPoint(x: snappedX, y: snappedY)
    }
    
    func getSnappedElementCorners(_ element: OOPElementRepresentation, gridSize: Double) -> (topLeft: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint, topRight: CGPoint) {
        let center = snapToGrid(element.position, gridSize: gridSize)
        
        let tLeft = snapToGrid(CGPoint(x: center.x - element.size.width / 2, y: center.y - element.size.height / 2), gridSize: gridSize)
        let bLeft = snapToGrid(CGPoint(x: center.x - element.size.width / 2, y: center.y + element.size.height / 2), gridSize: gridSize)
        let tRight = snapToGrid(CGPoint(x: center.x + element.size.width / 2, y: center.y - element.size.height / 2), gridSize: gridSize)
        let bRight = snapToGrid(CGPoint(x: center.x + element.size.width / 2, y: center.y + element.size.height / 2), gridSize: gridSize)
        
        return (topLeft: tLeft, bottomLeft: bLeft, bottomRight: bRight, topRight: tRight)
    }
    
    func adjustPositionFromCorners(_ corners: (topLeft: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint, topRight: CGPoint), element: inout OOPElementRepresentation) {
        let centerX = (corners.topLeft.x + corners.bottomRight.x) / 2
        let centerY = (corners.topLeft.y + corners.bottomRight.y) / 2
        let newPosition = CGPoint(x: centerX, y: centerY)
        
        element.position = newPosition
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
    /// - Returns: whether there is or isn't a connection between the given elements
    func checkIfConnectionExists(
        _ startElement: OOPElementRepresentation,
        _ endElement: OOPElementRepresentation
    ) -> Bool {
        guard let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) else { return false }
        let connections = document.diagrams[diagramIndex].entityConnections
        
        if connections.contains(where: { $0.startElement == startElement && $0.endElement == endElement }) {
            return true
        } else if connections.contains(where: { $0.startElement == endElement && $0.endElement == startElement }) {
            return true
        } else {
            return false
        }
    }
    
    func updateConnections(for element: inout OOPElementRepresentation) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            for index in document.diagrams[diagramIndex].entityConnections.indices {
                if document.diagrams[diagramIndex].entityConnections[index].startElement.id == element.id {
                    document.diagrams[diagramIndex].entityConnections[index].startElement.position = element.position
                } else if document.diagrams[diagramIndex].entityConnections[index].endElement.id == element.id {
                    document.diagrams[diagramIndex].entityConnections[index].endElement.position = element.position
                }
            }
        }
    }
    
    func updateElementPosition(_ element: Binding<OOPElementRepresentation>, value: DragGesture.Value) {
        element.wrappedValue.position = value.location
        self.updateConnections(for: &element.wrappedValue)
    }
    
    func handleDragGesture(_ element: Binding<OOPElementRepresentation>) -> some Gesture {
        DragGesture()
            .onChanged { [self] value in
                if element.wrappedValue.isSelected {
                    updateElementPosition(element, value: value)
                } else {
                    newConnection(
                        from: value.startLocation,
                        to: value.predictedEndLocation,
                        location: value.location
                    )
                }
            }
            .onEnded { [self] _ in
                if snapToGrid {
                    let snappedCorners = getSnappedElementCorners(element.wrappedValue, gridSize: gridSize)
                    adjustPositionFromCorners(snappedCorners, element: &element.wrappedValue)
                }
            }
    }
    
    func handleEntityChange(newValue: OOPElementRepresentation, diagramIndex: Int) {
        if let index = document.diagrams[diagramIndex].entityRepresentations.firstIndex(where: { $0.id == newValue.id }) {
            document.diagrams[diagramIndex].entityRepresentations[index] = newValue
        }
    }
}
