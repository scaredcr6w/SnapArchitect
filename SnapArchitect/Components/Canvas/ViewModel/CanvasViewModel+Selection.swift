//
//  CanvasViewModel+DragSelect.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 14..
//

import Foundation
import SwiftUI

extension CanvasViewModel {
    func deselectAll() {
        ToolManager.deselectAll()
    }
    
    func selectElement(element: inout OOPElementRepresentation) {
        deselectAll()
        element.isSelected = true
    }
    
    func selectConnection(connection: inout OOPConnectionRepresentation) {
        deselectAll()
        connection.isSelected = true
    }
    
    func updateSelectionRect(_ rect: CGRect) {
        selectionRect = rect
    }
    
    func startDragSelection(_ value: DragGesture.Value) {
        if dragStartLocation == nil {
            dragStartLocation = value.startLocation
            isDraging = true
        }
        
        if let start = dragStartLocation {
            let rect = CGRect(
                x: min(start.x, value.location.x),
                y: min(start.y, value.location.y),
                width: abs(start.x - value.location.x),
                height: abs(start.y - value.location.y)
            )
            
            selectionRect = rect
            dragSelection(with: rect)
        }
    }
    
    func endDragSelection() {
        dragStartLocation = nil
        isDraging = false
    }
    
    func dragSelection(with rect: CGRect) {
        guard let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        for index in document.diagrams[diagramIndex].entityRepresentations.indices {
            let element = document.diagrams[diagramIndex].entityRepresentations[index]
            if rect.contains(element.position) {
                document.diagrams[diagramIndex].entityRepresentations[index].isSelected = true
            }
        }
        
        for index in document.diagrams[diagramIndex].entityConnections.indices {
            let connection = document.diagrams[diagramIndex].entityConnections[index]
            if rect.contains(connection.startElement.position) || rect.contains(connection.endElement.position) {
                document.diagrams[diagramIndex].entityConnections[index].isSelected = true
            }
        }
    }
}
