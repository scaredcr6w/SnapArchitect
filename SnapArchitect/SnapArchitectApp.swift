//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct SnapArchitectApp: App {
    @StateObject var keyPressManager = KeyPressManager()
    @StateObject var toolManager = ToolManager()
    
    var body: some Scene {
        DocumentGroup(newDocument: SnapArchitectDocument()) { file in
            EditorView(document: file.$document)
                .environmentObject(toolManager)
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        maximizeWindow(window) 
                    }
                    keyPressManager.setupKeyListeners(file.$document)
                }
                .onDisappear {
                    keyPressManager.removeKeyPressListener()
                }
        }
        
        Settings {
            SettingsView()
        }
    }
    
    func maximizeWindow(_ window: NSWindow) {
        if let screen = window.screen {
            let screenRect = screen.visibleFrame
            window.setFrame(screenRect, display: true, animate: true)
        }
    }
}
