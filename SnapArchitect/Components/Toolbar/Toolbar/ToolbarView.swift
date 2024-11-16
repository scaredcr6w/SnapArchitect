//
//  ToolbarView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarView: View {
    @State private var expandedCategories: Set<String> = []
    @State private var elementDisclosureGruopExpanded: Bool = true
    @State private var connectionDisclosureGruopExpanded: Bool = true
    @StateObject private var viewModel = ToolbarViewModel()
    
    @ViewBuilder
    private func disclosureGroupElementItem(_ category: [ToolbarElementItem]) -> some View {
        VStack (alignment: .leading, spacing: 10) {
            ForEach(category) { toolbarItem in
                ToolbarItemView(
                    toolbarItem.elementName,
                    toolbarItem.elementType
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectTool(toolbarItem)
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
                    toolbarItem.elementType
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectTool(toolbarItem)
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
                        disclosureGroupElementItem(viewModel.basicClasses)
                    }
                    Divider()
                    DisclosureGroup("Connections", isExpanded: $connectionDisclosureGruopExpanded) {
                        disclosureGroupConnectionItem(viewModel.connections)
                    }
                    Divider()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
