//
//  EditElementView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 09/09/2024.
//

import SwiftUI

struct EditElementView: View {
    @Binding var element: OOPElementRepresentation
    @State private var showAddAttribute: Bool = false
    @State private var showAddFunction: Bool = false
    @State private var newAttributeName: String = ""
    @State private var newAttributeType: String = ""
    @State private var newFunctionName: String = ""
    @State private var newFunctionReturnType: String = ""
    @State private var newFunctionBody: String = ""
    var body: some View {
        VStack {
            Text("Edit Element")
                .font(.title3)
                .foregroundStyle(.gray)
            Divider()
        }
        ScrollView {
            Form {
                Section {
                    TextField("", text: $element.name, prompt: Text(element.name))
                        .padding(.horizontal)
                } header: {
                    Text("Edit name")
                }
                Section {
                    if showAddAttribute {
                        TextField("", text: $newAttributeName, prompt: Text("Name"))
                            .padding(.horizontal)
                        TextField("", text: $newAttributeType, prompt: Text("Type"))
                            .padding(.horizontal)
                        Button("Add") {
                            element.attributes.append(
                                OOPElementAttribute(
                                    access: .accessPublic,
                                    name: newAttributeName,
                                    type: newAttributeType
                                )
                            )
                            newAttributeName = ""
                            newAttributeType = ""
                            withAnimation(.easeInOut) {
                                showAddAttribute.toggle()
                            }
                        }
                    }
                    ForEach($element.attributes) { $attribute in
                        AttributeRowView(attribute: $attribute)
                    }
                } header: {
                    HStack {
                        Text("Edit attributes")
                        Image(systemName: "plus")
                            .background()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showAddAttribute.toggle()
                                }
                            }
                    }
                }
                Section {
                    if showAddFunction {
                        TextField("", text: $newFunctionName, prompt: Text("Name"))
                            .padding(.horizontal)
                        TextField("", text: $newFunctionReturnType, prompt: Text("Return Type"))
                            .padding(.horizontal)
                        TextEditor(text: $newFunctionBody)
                            .frame(height: 100)
                            .padding(.trailing)
                        Button("Add") {
                            element.functions.append(
                                OOPElementFunction(
                                    access: .accessPublic,
                                    name: newFunctionName,
                                    returnType: newFunctionReturnType,
                                    functionBody: newFunctionBody
                                )
                            )
                            newFunctionName = ""
                            newFunctionBody = ""
                            withAnimation(.easeInOut) {
                                showAddFunction.toggle()
                            }
                        }
                    }
                    ForEach($element.functions) { $function in
                        FunctionRowView(function: $function)
                    }
                } header: {
                    HStack {
                        Text("Edit functions")
                        Image(systemName: "plus")
                            .background()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showAddFunction.toggle()
                                }
                            }
                    }
                }

            }
            Spacer()
        }
    }
}

struct AttributeRowView: View {
    @Binding var attribute: OOPElementAttribute
    @State private var showEditor: Bool = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "minus.circle.fill")
                    .padding(.horizontal, 5)
                Image(systemName: "pencil")
                    .padding(.horizontal, 5)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showEditor.toggle()
                        }
                    }
                Text(attribute.name)
                    .frame(width: 130)
                Divider()
                Text(attribute.type)
                    .frame(width: 60)
            }
            .frame(height: 50)
            .frame(maxWidth: 300)
            
            VStack {
                if showEditor {
                    TextField("", text: $attribute.name)
                    TextField("", text: $attribute.type)
                }
            }
            .frame(maxHeight: showEditor ? .none : 0)
            .opacity(showEditor ? 1 : 0)
            .animation(.easeInOut, value: showEditor)
        }
    }
}

struct FunctionRowView: View {
    @Binding var function: OOPElementFunction
    @State private var showEditor: Bool = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "minus.circle.fill")
                    .padding(.horizontal, 5)
                Image(systemName: "pencil")
                    .padding(.horizontal, 5)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showEditor.toggle()
                        }
                    }
                Text(function.name)
                    .frame(width: 130)
                Text(function.returnType)
                    .frame(width: 60)
            }
            .frame(height: 50)
            .frame(maxWidth: 300)
            
            VStack {
                if showEditor {
                    TextField("", text: $function.name)
                    TextField("", text: $function.returnType)
                    TextEditor(text: $function.functionBody)
                        .frame(height: 100)
                }
            }
            .frame(maxHeight: showEditor ? .none : 0)
            .opacity(showEditor ? 1 : 0)
            .animation(.easeInOut, value: showEditor)
        }
    }
}
