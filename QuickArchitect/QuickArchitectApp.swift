//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct QuickArchitectApp: App {
    @State var selectedTool: OOPElementType? = nil
    @State var selectedElement: OOPElementRepresentation? = nil
    
    var body: some Scene {
        DocumentGroup(newDocument: QuickArchitectDocument()) { file in
            EditorView(document: file.$document, selectedTool: $selectedTool, selectedElement: $selectedElement)
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        maximizeWindow(window)
                    }
                }
        }
        Window("Edit", id: "edit-element") {
            if let element = selectedElement {
                let bindingElement = Binding<OOPElementRepresentation>(
                    get: { element },
                    set: { selectedElement = $0 }
                )
                EditElementView(element: bindingElement)
                    .onAppear {
                        if let window = NSApplication.shared.windows.first(where: { $0.title == "Edit"}) {
                            setEditWindowSize(window)
                        }
                    }
            } else {
                Text("No element selected")
            }
        }
    }
    
    func maximizeWindow(_ window: NSWindow) {
        if let screen = window.screen {
            let screenRect = screen.visibleFrame
            window.setFrame(screenRect, display: true, animate: true)
        }
    }
    
    func setEditWindowSize(_ window: NSWindow) {
        if let screen = window.screen {
            let screenRect = NSRect(x: 500, y: 500, width: 250, height: 300)
            window.setFrame(screenRect, display: true, animate: true)
        }
    }
}
