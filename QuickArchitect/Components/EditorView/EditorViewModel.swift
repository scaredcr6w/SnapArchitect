//
//  EditorViewModel.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 24..
//

import Foundation
import SwiftUI

final class EditorViewModel: ObservableObject {
    func setupKeyPressListener(_ document: Binding<QuickArchitectDocument>, _ selectedElement: Binding<OOPElementRepresentation?>) {
        NotificationCenter.default.addObserver(forName: NSApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 51 {
                    if let selectedElement = selectedElement.wrappedValue {
                        document.wrappedValue.entityRepresentations.removeAll(where: { $0.id == selectedElement.id })
                        return nil
                    }
                }
                return event
            }
        }
    }
    
    func removeKeyPressListener() {
        NotificationCenter.default.removeObserver(self, name: NSApplication.didBecomeActiveNotification, object: nil)
    }
}
