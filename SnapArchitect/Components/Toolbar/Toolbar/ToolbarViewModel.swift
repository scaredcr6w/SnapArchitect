//
//  ToolbarViewModel.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation

struct ToolbarElementItem: Identifiable, Hashable {
    let id = UUID()
    let elementName: String
    var elementType: OOPElementType?
}

struct ToolbarConnectionItem: Identifiable, Hashable {
    let id = UUID()
    let elementName: String
    var elementType: OOPConnectionType?
}

final class ToolbarViewModel: ObservableObject {
    
    let basicClasses = [
        ToolbarElementItem(elementName: "Class", elementType: .classType),
        ToolbarElementItem(elementName: "Struct", elementType: .structType),
        ToolbarElementItem(elementName: "Protocol", elementType: .protocolType),
        ToolbarElementItem(elementName: "Enum", elementType: .enumType)
    ]
    
    let connections = [
        ToolbarConnectionItem(elementName: "Association", elementType: .association),
        ToolbarConnectionItem(elementName: "Directed Association", elementType: .directedAssociation),
        ToolbarConnectionItem(elementName: "Aggregation", elementType: .aggregation),
        ToolbarConnectionItem(elementName: "Composition", elementType: .composition),
        ToolbarConnectionItem(elementName: "Dependency", elementType: .dependency),
        ToolbarConnectionItem(elementName: "Generalization", elementType: .generalization),
        ToolbarConnectionItem(elementName: "Protocol Realization", elementType: .protocolRealization)
    ]
    
    func selectTool(_ toolbarItem: ToolbarElementItem) {
        ToolManager.shared.selectedTool = toolbarItem.elementType
    }
    
    func selectTool(_ toolbarItem: ToolbarConnectionItem) {
        ToolManager.shared.selectedTool = toolbarItem.elementType
    }
}
