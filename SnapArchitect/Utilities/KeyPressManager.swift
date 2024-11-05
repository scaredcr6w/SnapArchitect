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
        _ document: Binding<SnapArchitectDocument>
    ) {
        if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
            document.wrappedValue.diagrams[diagramIndex].entityRepresentations.removeAll(
                where: { $0.isSelected }
            )
        }
    }
    
    private func deleteConnection(
        _ document: Binding<SnapArchitectDocument>
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
                if let diagramIndex = document.wrappedValue.diagrams.firstIndex(where: { $0.isSelected }) {
                    let selectedElementsCount = document.wrappedValue.diagrams[diagramIndex].entityRepresentations.lazy.filter({ $0.isSelected }).count
                    let selectedConnectionCount = document.wrappedValue.diagrams[diagramIndex].entityConnections.lazy.filter({ $0.isSelected }).count
                    if selectedElementsCount > 0 {
                        self.deleteElement(document)
                    }
                    if selectedConnectionCount > 0 {
                        self.deleteConnection(document)
                    }
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
