//
//  ToolbarItems.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation

protocol ToolbarItem: Identifiable {
    var type: String { get set }
    var position: CGPoint { get set }
}

struct ClassRepresentation: ToolbarItem {
    var id = UUID()
    var type: String
    var position: CGPoint
    
    init(type: String = "Class", position: CGPoint) {
        self.type = type
        self.position = position
    }
}
