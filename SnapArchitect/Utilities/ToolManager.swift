//
//  ToolManager.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 25..
//

import Foundation
import AppKit

class ToolManager: ObservableObject {
    @Published var selectedTool: Any? = nil {
        didSet {
            updateMouseCursor()
        }
    }
    @Published var selectedElement: OOPElementRepresentation? = nil {
        didSet {
            if selectedConnection != nil{
                selectedConnection = nil
            }
        }
    }
    @Published var selectedConnection: OOPConnectionRepresentation? = nil {
        didSet {
            if selectedElement != nil {
                selectedElement = nil
            }
        }
    }
    
    private var cursorPushed: Bool = false
    
    func updateMouseCursor() {
        if cursorPushed {
            NSCursor.pop()
            cursorPushed = false
        }
        
        if selectedTool is OOPElementType {
            NSCursor.closedHand.push()
            cursorPushed = true
        } else if selectedTool is OOPConnectionType {
            NSCursor.crosshair.push()
            cursorPushed = true
        } else {
            resetMouseCursor()
        }
    }
    
    func resetMouseCursor() {
        NSCursor.arrow.set()
        if cursorPushed {
            NSCursor.pop()
            cursorPushed = false
        }
    }
}
