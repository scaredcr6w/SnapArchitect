//
//  ToolbarView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarCategory: Identifiable, Hashable {
    let id = UUID()
    let categoryName: String
    var type: OOPElementType?
    var items: [ToolbarCategory]?
}

struct ToolbarView: View {
    let viewModel: ToolbarViewModel
    @Binding var selectedTool: OOPElementType?
    @State private var expandedCategories: Set<String> = []
    
    let categories = [
        ToolbarCategory(
            categoryName: "Basic",
            items: [
                ToolbarCategory(categoryName: "Class", type: .classType),
                ToolbarCategory(categoryName: "Struct", type: .structType),
                ToolbarCategory(categoryName: "Protocol", type: .protocolType),
                ToolbarCategory(categoryName: "Enum", type: .enumType)
            ]
        )
    ]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(Color.darkGray)
            VStack {
                Text("Toolbar")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                List {
                    ForEach(categories) { category in
                        Section {
                            if expandedCategories.contains(category.categoryName) {
                                ForEach(category.items ?? []) { item in
                                    Text(item.categoryName)
                                        .background(
                                            item.type == selectedTool ? Color.blue : Color.clear
                                        )
                                        .onTapGesture {
                                            selectedTool = item.type
                                        }
                                }
                            }
                        } header: {
                            Text(category.categoryName)
                        }
                        .onTapGesture {
                            toggleCategoryExpansion(category.categoryName)
                        }
                        
                    }
                }
            }
        }
        .frame(width: 300, height: 800)
    }
    
    private func toggleCategoryExpansion(_ categoryName: String) {
        if expandedCategories.contains(categoryName) {
            expandedCategories.remove(categoryName)
        } else {
            expandedCategories.insert(categoryName)
        }
    }
}
