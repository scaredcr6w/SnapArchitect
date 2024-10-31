//
//  KeyPressManager.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 25..
//

import Foundation
import SwiftUI

class KeyPressManager: ObservableObject {
    private var eventMonitor: Any?
    
    private func deleteElement(
        _ document: Binding<SnapArchitectDocument>,
        _ elements: [OOPElementRepresentation]
    ) {
        if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
            document.wrappedValue.diagrams[diagramIndex].entityRepresentations.removeAll(
                where: { $0.isSelected }
            )
            
            for element in elements {
                document.wrappedValue.diagrams[diagramIndex].entityConnections.removeAll { connection in
                    connection.startElement.id == element.id || connection.endElement.id == element.id
                }
            }
        }
    }
    
    private func deleteConnection(
        _ document: Binding<SnapArchitectDocument>,
        _ selectedConnections: [OOPConnectionRepresentation]
    ) {
        if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
            document.wrappedValue.diagrams[diagramIndex].entityConnections.removeAll(
                where: { $0.isSelected }
            )
        }
    }
    
    func setupKeyListeners(
        _ document: Binding<SnapArchitectDocument>,
        _ toolManager: ToolManager
    ) {
        removeKeyPressListener()
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.keyCode == 51 {
                if !toolManager.selectedElements.isEmpty {
                    self.deleteElement(document, toolManager.selectedElements)
                }
                if !toolManager.selectedConnections.isEmpty {
                    self.deleteConnection(document, toolManager.selectedConnections)
                }
            }
            if event.keyCode == 53 {
                toolManager.selectedTool = nil
            }
            return event
        }
    }
    
    func removeKeyPressListener() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
