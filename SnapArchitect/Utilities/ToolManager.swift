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
    @Published var selectionRect: CGRect = .zero
    @Published var isDragging: Bool = false
    @Published var dragStartLocation: CGPoint? = nil
    
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
    
    func deselectAll(in document: inout SnapArchitectDocument) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            for index in document.diagrams[diagramIndex].entityRepresentations.indices {
                document.diagrams[diagramIndex].entityRepresentations[index].isSelected = false
            }
            
            for index in document.diagrams[diagramIndex].entityConnections.indices {
                document.diagrams[diagramIndex].entityConnections[index].isSelected = false
            }
        }
    }
    
    func dragSelection(with rect: CGRect, in document: inout SnapArchitectDocument) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            for index in document.diagrams[diagramIndex].entityRepresentations.indices {
                let element = document.diagrams[diagramIndex].entityRepresentations[index]
                if rect.contains(element.position) {
                    document.diagrams[diagramIndex].entityRepresentations[index].isSelected = true
                }
            }
            
            for index in document.diagrams[diagramIndex].entityConnections.indices {
                let connection = document.diagrams[diagramIndex].entityConnections[index]
                if rect.contains(connection.startElement.position) || rect.contains(connection.endElement.position) {
                    document.diagrams[diagramIndex].entityConnections[index].isSelected = true
                }
            }
        }
    }
}
