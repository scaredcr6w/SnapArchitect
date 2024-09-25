//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct QuickArchitectApp: App {
    @ObservedObject var keyPressManager = KeyPressManager()
    @ObservedObject var toolManager = ToolManager()
    
    var body: some Scene {
        DocumentGroup(newDocument: QuickArchitectDocument()) { file in
            EditorView(document: file.$document, selectedTool: $toolManager.selectedTool, selectedElement: $toolManager.selectedElement)
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        maximizeWindow(window)
                    }
                    keyPressManager.setupKeyListeners(file.$document, $toolManager.selectedElement)
                }
                .onDisappear {
                    keyPressManager.removeKeyPressListener()
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
        if window.screen != nil {
            let screenRect = NSRect(x: 500, y: 500, width: 250, height: 300)
            window.setFrame(screenRect, display: true, animate: true)
        }
    }
}
