//
//  ToolbarItems.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import Foundation
import SwiftUI

enum OOPElementType: String, Codable {
    case classType
    case structType
    case protocolType
    case enumType
    case association
    case directedAssociation
    case aggregation
    case composition
    case dependency
    case generalization
    case protocolRealization
}

protocol OOPElement: Identifiable, Hashable, Codable {
    var type: OOPElementType { get set }
    var position: CGPoint { get set }
}

struct OOPElementRepresentation: OOPElement {
    var id = UUID()
    var type: OOPElementType
    var position: CGPoint
    
    init(type: OOPElementType, position: CGPoint) {
        self.type = type
        self.position = position
    }
}

