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
    case extensionType
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case position
    }
    
    static func == (lhs: OOPElementRepresentation, rhs: OOPElementRepresentation) -> Bool {
        return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(position)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(OOPElementType.self, forKey: .type)
        position = try container.decode(CGPoint.self, forKey: .position)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(position, forKey: .position)
    }
}

