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
        _ document: Binding<QuickArchitectDocument>,
        _ selectedElement: OOPElementRepresentation?
    ) {
        if let selectedElement = selectedElement {
            document.wrappedValue.entityRepresentations.removeAll(
                where: { $0 == selectedElement }
            )
            document.wrappedValue.entityConnections.removeAll(
                where: { $0.startElement == selectedElement || $0.endElement == selectedElement }
            )
        }
    }
    
    func setupKeyListeners(
        _ document: Binding<QuickArchitectDocument>,
        _ toolManager: ToolManager
    ) {
        removeKeyPressListener()
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.keyCode == 51 {
                self.deleteElement(document, toolManager.selectedElement)
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
