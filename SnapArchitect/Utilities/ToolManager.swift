//
//  ToolManager.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 25..
//

import Foundation
import AppKit

class ToolManager: ObservableObject {
    static let shared = ToolManager()
    
    // MARK: Published Properties
    @Published var selectedTool: Any? = nil {
        didSet {
            NotificationCenter.default.post(name: .toolSelected, object: nil)
        }
    }
    @Published var selectionRect: CGRect = .zero
    @Published var isDragging: Bool = false
    @Published var isEditing: Bool = false
    @Published var dragStartLocation: CGPoint? = nil
    
    var document: SnapArchitectDocument?
    
    private init() {}
    
    // MARK: - Singleton Methods
    static func deselectAll() {
        shared.deselectAllElements()
    }
    
    private func deselectAllElements() {
        guard let diagramIndex = document?.diagrams.firstIndex(where: { $0.isSelected }) else { return }
        document?.diagrams[diagramIndex].entityRepresentations.indices.forEach { index in
            document?.diagrams[diagramIndex].entityRepresentations[index].isSelected = false
        }
        document?.diagrams[diagramIndex].entityConnections.indices.forEach { index in
            document?.diagrams[diagramIndex].entityConnections[index].isSelected = false
        }
    }
    
    static func dragSelection(with rect: CGRect) {
        shared.dragSelection(rect)
    }
    
    private func dragSelection(_ rect: CGRect) {
        guard let document = document else { return }
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
