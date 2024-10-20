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
    @EnvironmentObject private var toolManager: ToolManager
    @State private var expandedCategories: Set<String> = []
    @State private var elementDisclosureGruopExpanded: Bool = true
    @State private var connectionDisclosureGruopExpanded: Bool = true
    
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
                    toolbarItem.elementType == toolManager.selectedTool as? OOPElementType
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    toolManager.selectedTool = toolbarItem.elementType
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
                    toolbarItem.elementType == toolManager.selectedTool as? OOPConnectionType
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    toolManager.selectedTool = toolbarItem.elementType
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
                    DisclosureGroup("Basic Classes", isExpanded: $elementDisclosureGruopExpanded) {
                        disclosureGroupElementItem(ToolbarView.basicClasses)
                    }
                    Divider()
                    DisclosureGroup("Connections", isExpanded: $connectionDisclosureGruopExpanded) {
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
