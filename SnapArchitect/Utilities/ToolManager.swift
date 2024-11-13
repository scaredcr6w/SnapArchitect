//
//  ToolManager.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 25..
//

import Foundation
import AppKit

class ToolManager: ObservableObject {
    public static var selectedTool: Any? = nil {
        didSet {
            NotificationCenter.default.post(name: .toolSelected, object: nil)
        }
    }
    public static var selectionRect: CGRect = .zero
    public static var isDragging: Bool = false
    public static var isEditing: Bool = false
    public static var dragStartLocation: CGPoint? = nil
    
    private var cursorPushed: Bool = false
    
    static func deselectAll(in document: inout SnapArchitectDocument) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            for index in document.diagrams[diagramIndex].entityRepresentations.indices {
                document.diagrams[diagramIndex].entityRepresentations[index].isSelected = false
            }
            
            for index in document.diagrams[diagramIndex].entityConnections.indices {
                document.diagrams[diagramIndex].entityConnections[index].isSelected = false
            }
        }
    }
    
    static func dragSelection(with rect: CGRect, in document: inout SnapArchitectDocument) {
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
