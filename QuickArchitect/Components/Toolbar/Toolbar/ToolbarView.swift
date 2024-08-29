//
//  ToolbarView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarCategory: Identifiable, Hashable {
    let id = UUID()
    let elementName: String
    var elementType: OOPElementType?
}

struct ToolbarView: View {
    let viewModel: ToolbarViewModel
    @Binding var selectedTool: OOPElementType?
    @State private var expandedCategories: Set<String> = []
    
    let basicCategories = [
        ToolbarCategory(elementName: "Class", elementType: .classType),
        ToolbarCategory(elementName: "Struct", elementType: .structType),
        ToolbarCategory(elementName: "Protocol", elementType: .protocolType),
        ToolbarCategory(elementName: "Enum", elementType: .enumType)
    ]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(Color.primaryDarkGray)
            VStack {
                Text("Toolbar")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                DisclosureGroup("Basic") {
                    ForEach(basicCategories) { category in
                        Text(category.elementName)
                            .onTapGesture {
                                selectedTool = category.elementType
                            }
                    }
                }
            }
            .padding()
        }
        .frame(width: 270)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func toggleCategoryExpansion(_ categoryName: String) {
        if expandedCategories.contains(categoryName) {
            expandedCategories.remove(categoryName)
        } else {
            expandedCategories.insert(categoryName)
        }
    }
}
