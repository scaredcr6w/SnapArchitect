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
    
    private func deleteElement() {
        guard let diagramIndex = ToolManager.shared.document?.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        ToolManager.shared.document?.diagrams[diagramIndex].entityRepresentations.removeAll { $0.isSelected }
    }
    
    private func deleteConnection() {
        guard let diagramIndex = ToolManager.shared.document?.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        ToolManager.shared.document?.diagrams[diagramIndex].entityConnections.removeAll { $0.isSelected }
    }
    
    func setupKeyListeners() {
        removeKeyPressListener()
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if ToolManager.shared.isEditing {
                return event
            }
            if event.modifierFlags.contains(.command) && event.keyCode == 51 {
                if let diagramIndex = ToolManager.shared.document?.diagrams.firstIndex(where: { $0.isSelected }) {
                    let selectedElementsCount =
                    ToolManager.shared.document?.diagrams[diagramIndex].entityRepresentations.lazy.filter(
                        { $0.isSelected }
                    ).count ?? 0
                    
                    let selectedConnectionCount =
                    ToolManager.shared.document?.diagrams[diagramIndex].entityConnections.lazy.filter(
                        { $0.isSelected }
                    ).count ?? 0
                    
                    if selectedElementsCount > 0 {
                        self.deleteElement()
                    }
                    if selectedConnectionCount > 0 {
                        self.deleteConnection()
                    }
                }
            }
            if event.keyCode == 53 {
                ToolManager.shared.selectedTool = nil
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
