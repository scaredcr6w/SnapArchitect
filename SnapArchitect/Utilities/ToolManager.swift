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
    @Published var isEditing: Bool = false
    
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
}
