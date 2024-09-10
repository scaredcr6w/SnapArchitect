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
    var id: UUID { get set }
    var name: String { get set }
    var type: OOPElementType { get set }
    var position: CGPoint { get set }
    var size: CGSize { get set }
    var attributes: [OOPElementAttribute] { get set }
    var functions: [OOPElementFunction] { get set }
}

struct OOPElementAttribute: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var type: String
}

struct OOPElementFunction: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var functionBody: String
}

struct OOPElementRepresentation: OOPElement {
    var id = UUID()
    var name: String
    var type: OOPElementType
    var position: CGPoint
    var size: CGSize
    var attributes: [OOPElementAttribute]
    var functions: [OOPElementFunction]
    
    init(
        _ name: String,
        _ type: OOPElementType,
        _ position: CGPoint,
        _ size: CGSize,
        _ attributes: [OOPElementAttribute] = [],
        _ functions: [OOPElementFunction] = []
    ) {
        self.name = name
        self.type = type
        self.position = position
        self.size = size
        self.attributes = attributes
        self.functions = functions
    }
    
    mutating func update(
        name: String
    ) {
        self.name = name
    }
    
    mutating func update(
        attribute: OOPElementAttribute
    ) {
        self.attributes.append(attribute)
    }
    
    mutating func update(
        function: OOPElementFunction
    ) {
        self.functions.append(function)
    }
}

