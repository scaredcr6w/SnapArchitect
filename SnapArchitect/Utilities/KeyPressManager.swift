//
//  KeyPressManager.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 25..
//

import Foundation
import SwiftUI

final class KeyPressManager: ObservableObject {
    static let shared = KeyPressManager()
    
    private init() { }
    
    private var eventMonitor: Any?
    
    private func deleteElement() {
        guard let document = ToolManager.shared.document else { return }
        guard let diagramIndex = ToolManager.shared.document?.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        document.diagrams[diagramIndex].entityRepresentations.removeAll { $0.isSelected }
        
        for element in document.diagrams[diagramIndex].entityRepresentations {
            document.diagrams[diagramIndex].entityConnections.removeAll { connection in
                connection.startElement.id == element.id || connection.endElement.id == element.id
            }
        }
    }
    
    private func deleteConnection() {
        guard let diagramIndex = ToolManager.shared.document?.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        ToolManager.shared.document?.diagrams[diagramIndex].entityConnections.removeAll { $0.isSelected }
    }
    
    static func setup() {
        shared.setupKeyListeners()
    }
    
    private func setupKeyListeners() {
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
    
    static func remove() {
        shared.removeKeyPressListener()
    }
    
    private func removeKeyPressListener() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
