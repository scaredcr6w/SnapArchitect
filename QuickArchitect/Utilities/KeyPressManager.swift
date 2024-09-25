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
    
    func setupKeyListeners(_ document: Binding<QuickArchitectDocument>, _ selectedElement: Binding<OOPElementRepresentation?>) {
        removeKeyPressListener()
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 51 {
                if let selectedElement = selectedElement.wrappedValue {
                    document.wrappedValue.entityRepresentations.removeAll(where: { $0 == selectedElement })
                    document.wrappedValue.entityConnections.removeAll(where: { $0.startElement == selectedElement || $0.endElement == selectedElement })
                    return nil
                }
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
