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
    @StateObject private var viewModel = ToolbarViewModel()
    @Binding var selectedTool: OOPElementType?
    @Binding var selectedElement: OOPElementRepresentation?
    @State private var expandedCategories: Set<String> = []
    
    @State private var newName: String = ""
    @State private var newAttributeName: String = ""
    @State private var newAttributeType: String = ""
    @State private var newFunctionName: String = ""
    @State private var newFunctionBody: String = ""
    
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
            ScrollView {
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
                    if selectedElement != nil {
                        Form {
                            Section {
                                TextField("", text: $newName, prompt: Text(selectedElement?.name ?? ""))
                                    .onChange(of: newName) {
                                        selectedElement?.update(name: newName)
                                    }
                            } header: {
                                Text("Element name")
                                    .font(.headline)
                                    .padding(.top)
                            }
                            Section {
                                Table(selectedElement?.attributes ?? []) {
                                    TableColumn("Attribute name", value: \.name)
                                    TableColumn("Attribute type", value: \.type)
                                }
                                .frame(maxHeight: 200)
                                TextField("", text: $newAttributeName, prompt: Text("Name"))
                                TextField("", text: $newAttributeType, prompt: Text("Type"))
                                Button("Add") {
                                    selectedElement?.update(
                                        attribute: OOPElementAttribute(
                                            name: newAttributeName,
                                            type: newAttributeType)
                                    )
                                }
                            } header: {
                                Text("Attributes")
                                    .font(.headline)
                                    .padding(.top)
                            }
                            
                            Section {
                                if let element = selectedElement {
                                    ForEach(element.functions) { function in
                                        DisclosureGroup(function.name) {
                                            Text(function.functionBody)
                                        }
                                        .onTapGesture {
                                            newFunctionName = function.name
                                            newFunctionBody = function.functionBody
                                        }
                                    }
                                    TextField("", text: $newFunctionName, prompt: Text("Name"))
                                    TextEditor(text: $newFunctionBody)
                                    Button("Add") {
                                        selectedElement?.update(
                                            function: OOPElementFunction(
                                                name: newFunctionName,
                                                functionBody: newFunctionBody)
                                        )
                                    }
                                }
                            } header: {
                                Text("Functions")
                                    .font(.headline)
                                    .padding(.top)
                            }
                            
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .frame(width: 270)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
