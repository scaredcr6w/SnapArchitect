//
//  ToolbarView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarItem: Identifiable, Hashable {
    let id = UUID()
    let elementName: String
    var elementType: OOPElementType?
}

struct ToolbarView: View {
    let viewModel: ToolbarViewModel
    @Binding var selectedTool: OOPElementType?
    @State private var expandedCategories: Set<String> = []
    
    let basicClasses = [
        ToolbarItem(elementName: "Class", elementType: .classType),
        ToolbarItem(elementName: "Struct", elementType: .structType),
        ToolbarItem(elementName: "Protocol", elementType: .protocolType),
        ToolbarItem(elementName: "Enum", elementType: .enumType)
    ]
    
    let connections = [
        ToolbarItem(elementName: "Association", elementType: .association),
        ToolbarItem(elementName: "Directed Association", elementType: .directedAssociation),
        ToolbarItem(elementName: "Aggregation", elementType: .aggregation),
        ToolbarItem(elementName: "Composition", elementType: .composition),
        ToolbarItem(elementName: "Dependency", elementType: .dependency),
        ToolbarItem(elementName: "Generalization", elementType: .generalization),
        ToolbarItem(elementName: "Protocol Realization", elementType: .protocolRealization)
    ]
    
    @ViewBuilder
    private func disclosureGroupItem(_ category: [ToolbarItem]) -> some View {
        VStack (alignment: .leading, spacing: 10) {
            ForEach(category) { toolbarItem in
                ToolbarItemView(
                    toolbarItem.elementName,
                    toolbarItem.elementType == selectedTool
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
            Rectangle()
                .foregroundStyle(Color.primaryDarkGray)
            VStack {
                Text("Toolbar")
                    .font(.title3)
                    .foregroundStyle(.gray)
                Divider()
                DisclosureGroup("Basic Classes") {
                    disclosureGroupItem(basicClasses)
                }
                Divider()
                DisclosureGroup("Connections") {
                    disclosureGroupItem(connections)
                }
                Divider()
                Spacer()
            }
            .padding()
        }
        .frame(width: 270)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
