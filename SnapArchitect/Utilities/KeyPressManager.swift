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
        _ selectedElement: OOPElementRepresentation?
    ) {
        if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
            if let selectedElement = selectedElement {
                document.wrappedValue.diagrams[diagramIndex].entityRepresentations.removeAll(
                    where: { $0 == selectedElement }
                )
                document.wrappedValue.diagrams[diagramIndex].entityConnections.removeAll(
                    where: { $0.startElement == selectedElement || $0.endElement == selectedElement }
                )
            }
        }
    }
    
    private func deleteConnection(
        _ document: Binding<SnapArchitectDocument>,
        _ selectedConnection: OOPConnectionRepresentation?
    ) {
        if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
            if let selectedConnection = selectedConnection {
                document.wrappedValue.diagrams[diagramIndex].entityConnections.removeAll(
                    where: { $0 == selectedConnection }
                )
            }
        }
    }
    
    func setupKeyListeners(
        _ document: Binding<SnapArchitectDocument>,
        _ toolManager: ToolManager
    ) {
        removeKeyPressListener()
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.keyCode == 51 {
                if let selectedElement = toolManager.selectedElement {
                    self.deleteElement(document, selectedElement)
                }
                if let selectedConnection = toolManager.selectedConnection {
                    self.deleteConnection(document, selectedConnection)
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
