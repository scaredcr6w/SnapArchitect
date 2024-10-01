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
}

enum OOPConnectionType: String, Codable {
    case association
    case directedAssociation
    case aggregation
    case composition
    case dependency
    case generalization
    case protocolRealization
}

enum OOPAccessModifier: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case accessInternal
    case accessPublic
    case accessProtected
    case accessPrivate
    
    var stringValue: String {
        switch self {
        case .accessInternal:
            return "internal"
        case .accessPublic:
            return "public"
        case .accessProtected:
            return "protected"
        case .accessPrivate:
            return "private"
        }
    }
}

protocol OOPElement: Identifiable, Hashable, Codable {
    var id: UUID { get set }
    var access: OOPAccessModifier { get set }
    var name: String { get set }
    var type: OOPElementType { get set }
    var position: CGPoint { get set }
    var size: CGSize { get set }
    var attributes: [OOPElementAttribute] { get set }
    var functions: [OOPElementFunction] { get set }
}

struct OOPElementAttribute: Identifiable, Hashable, Codable {
    var id = UUID()
    var access: OOPAccessModifier
    var name: String
    var type: String
}

struct OOPElementFunction: Identifiable, Hashable, Codable {
    var id = UUID()
    var access: OOPAccessModifier
    var name: String
    var returnType: String
    var functionBody: String
}

struct OOPElementRepresentation: OOPElement {
    var id = UUID()
    var access: OOPAccessModifier
    var name: String
    var type: OOPElementType
    var position: CGPoint
    var size: CGSize
    var attributes: [OOPElementAttribute]
    var functions: [OOPElementFunction]
    
    init(
        _ access: OOPAccessModifier,
        _ name: String,
        _ type: OOPElementType,
        _ position: CGPoint,
        _ size: CGSize,
        _ attributes: [OOPElementAttribute] = [],
        _ functions: [OOPElementFunction] = []
    ) {
        self.access = access
        self.name = name
        self.type = type
        self.position = position
        self.size = size
        self.attributes = attributes
        self.functions = functions
    }
}

struct OOPConnectionRepresentation: Identifiable, Hashable, Codable{
    var id = UUID()
    var type: OOPConnectionType
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    
    init(type: OOPConnectionType, startElement: OOPElementRepresentation, endElement: OOPElementRepresentation) {
        self.type = type
        self.startElement = startElement
        self.endElement = endElement
    }
}
