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
    
    let documentProxy: DocumentProtocol
    
    init(
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProtocol
    ) {
        self.document = document
        self.documentProxy = documentProxy
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
    
    func getMouseClick(_ geoSize: CGSize, event: NSEvent) -> CGPoint {
        guard geoSize.width > 0, geoSize.height > 0 else { return .zero }
        let windowLocation = event.locationInWindow
        guard windowLocation.x > 0, windowLocation.y > 0 else { return .zero }
        
        let clickPosition = CGPoint(
            x: (windowLocation.x - xScrollOffset),
            y: (geoSize.height - windowLocation.y - yScrollOffset)
        )
        return clickPosition
    }
    
    func getCurrentClickLocation(geo: GeometryProxy) -> CGPoint {
        guard let event = NSApp.currentEvent else { return .zero }
        return getMouseClick(geo.size, event: event)
    }
    
    /// Creates a new OOPElementrRepresentation and adds it to the document
    /// - Parameters:
    ///   - geo: the geometry of the CanvasView
    func newElement(at clickLocation: CGPoint, size: CGSize = CGSize(width: 100, height: 100)) {
        guard let selectedTool = ToolManager.shared.selectedTool as? OOPElementType else { return }
        
        let newElement = OOPElementRepresentation(
            .accessPublic,
            selectedTool.rawValue,
            selectedTool,
            clickLocation,
            size
        )
        
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            document.diagrams[diagramIndex].entityRepresentations.append(newElement)
            
            // Register Undo Action
            documentProxy.registerUndo(with: self) { target in
                target.removeElement(newElement)
            }
            
            documentProxy.updateDocument()
            ToolManager.shared.selectedTool = nil
        }
    }
    
    func removeElement(_ element: OOPElementRepresentation) {
        guard let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        document.diagrams[diagramIndex].entityRepresentations.removeAll(where: { $0 == element })
        documentProxy.updateDocument()
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
        guard !checkIfConnectionExists(startElement, endElement) else { return }
        let connection = OOPConnectionRepresentation(
            type: selectedTool,
            startElement: startElement,
            endElement: endElement
        )
        
        document.diagrams[diagramIndex].entityConnections.append(connection)
        
        documentProxy.registerUndo(with: self) { target in
            target.removeConnection(connection)
        }
        
        ToolManager.shared.selectedTool = nil
        documentProxy.updateDocument()
    }
    
    func removeConnection(_ connection: OOPConnectionRepresentation) {
        guard let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        document.diagrams[diagramIndex].entityConnections.removeAll(where: { $0 == connection })
        documentProxy.updateDocument()
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
    
    func updateElementPosition(_ element: Binding<OOPElementRepresentation>, newPosition: CGPoint) {
        let previousPosition = element.wrappedValue.position
        documentProxy.registerUndo(with: self) { target in
            self.updateElementPosition(element, newPosition: previousPosition)
        }
        
        element.wrappedValue.position = newPosition
        documentProxy.updateDocument()
        self.updateConnections(for: &element.wrappedValue)
    }
    
    func handleDragGesture(_ element: Binding<OOPElementRepresentation>) -> some Gesture {
        DragGesture()
            .onChanged { [self] value in
                if element.wrappedValue.isSelected {
                    updateElementPosition(element, newPosition: value.location)
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
