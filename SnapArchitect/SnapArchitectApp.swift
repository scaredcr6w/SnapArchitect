//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct SnapArchitectApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { SnapArchitectDocument() }) { file in
            EditorView()
                .environmentObject(file.document)
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        maximizeWindow(window)
                    }
                    ToolManager.shared.document = file.document
                    KeyPressManager.setup()
                }
                .onDisappear {
                    KeyPressManager.remove()
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
