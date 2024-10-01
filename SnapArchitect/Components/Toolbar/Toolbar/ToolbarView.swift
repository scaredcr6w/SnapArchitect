//
//  ToolbarView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

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

struct ToolbarView: View {
    @Binding var selectedTool: Any?
    @Binding var selectedElement: OOPElementRepresentation?
    @State private var expandedCategories: Set<String> = []
    
    @State private var newName: String = ""
    @State private var newAttributeName: String = ""
    @State private var newAttributeType: String = ""
    @State private var newFunctionName: String = ""
    @State private var newFunctionBody: String = ""
    
    static let basicClasses = [
        ToolbarElementItem(elementName: "Class", elementType: .classType),
        ToolbarElementItem(elementName: "Struct", elementType: .structType),
        ToolbarElementItem(elementName: "Protocol", elementType: .protocolType),
        ToolbarElementItem(elementName: "Enum", elementType: .enumType)
    ]
    
    static let connections = [
        ToolbarConnectionItem(elementName: "Association", elementType: .association),
        ToolbarConnectionItem(elementName: "Directed Association", elementType: .directedAssociation),
        ToolbarConnectionItem(elementName: "Aggregation", elementType: .aggregation),
        ToolbarConnectionItem(elementName: "Composition", elementType: .composition),
        ToolbarConnectionItem(elementName: "Dependency", elementType: .dependency),
        ToolbarConnectionItem(elementName: "Generalization", elementType: .generalization),
        ToolbarConnectionItem(elementName: "Protocol Realization", elementType: .protocolRealization)
    ]
    
    @ViewBuilder
    private func disclosureGroupElementItem(_ category: [ToolbarElementItem]) -> some View {
        VStack (alignment: .leading, spacing: 10) {
            ForEach(category) { toolbarItem in
                ToolbarItemView(
                    toolbarItem.elementName,
                    toolbarItem.elementType == selectedTool as? OOPElementType
                )
                .onTapGesture {
                    selectedTool = toolbarItem.elementType
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func disclosureGroupConnectionItem(_ category: [ToolbarConnectionItem]) -> some View {
        VStack (alignment: .leading, spacing: 10) {
            ForEach(category) { toolbarItem in
                ToolbarItemView(
                    toolbarItem.elementName,
                    toolbarItem.elementType == selectedTool as? OOPConnectionType
                )
                .onTapGesture {
                    selectedTool = toolbarItem.elementType
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView {
                VStack {
                    Text("Toolbar")
                        .font(.title3)
                        .foregroundStyle(.gray)
                    Divider()
                    DisclosureGroup("Basic Classes") {
                        disclosureGroupElementItem(ToolbarView.basicClasses)
                    }
                    Divider()
                    DisclosureGroup("Connections") {
                        disclosureGroupConnectionItem(ToolbarView.connections)
                    }
                    Divider()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
