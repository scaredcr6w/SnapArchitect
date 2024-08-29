//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct QuickArchitectApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: QuickArchitectDocument()) { file in
            EditorView(document: file.$document)
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        maximizeWindow(window)
                    }
                }
        }
    }
    
    func maximizeWindow(_ window: NSWindow) {
        if let screen = window.screen {
            let screenRect = screen.visibleFrame
            window.setFrame(screenRect, display: true, animate: true)
        }
    }
}
