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
    var attributes: [String]? { get set }
    var functions: [OOPElementFunction]? { get set }
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
    var attributes: [String]?
    var functions: [OOPElementFunction]?
    
    init(
        _ name: String,
        _ type: OOPElementType,
        _ position: CGPoint,
        _ size: CGSize,
        _ attributes: [String]? = nil,
        _ functions: [OOPElementFunction]? = nil
    ) {
        self.name = name
        self.type = type
        self.position = position
        self.size = size
        self.attributes = attributes
        self.functions = functions
    }
}

