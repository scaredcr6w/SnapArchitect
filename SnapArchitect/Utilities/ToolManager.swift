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
}
