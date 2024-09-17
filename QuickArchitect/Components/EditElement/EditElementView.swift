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
    @State private var selectedAccessModifier: OOPAccessModifier = .accessPublic
    
    private func addAttribute() {
        let attribute = OOPElementAttribute(
            access: selectedAccessModifier,
            name: newAttributeName,
            type: newAttributeType
        )
        element.attributes.append(attribute)
        selectedAccessModifier = .accessPublic
        newAttributeName = ""
        newAttributeType = ""
    }
    
    private func addFunction() {
        let function = OOPElementFunction(
            access: selectedAccessModifier,
            name: newFunctionName,
            returnType: newFunctionReturnType,
            functionBody: newFunctionBody
        )
        element.functions.append(function)
        selectedAccessModifier = .accessPublic
        newFunctionName = ""
        newFunctionReturnType = ""
        newFunctionBody = ""
    }
    
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
                        .font(.title3)
                }
                Section {
                    if showAddAttribute {
                        Picker("", selection: $selectedAccessModifier) {
                            ForEach(OOPAccessModifier.allCases, id: \.self) { option in
                                Text(option.stringValue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        TextField("", text: $newAttributeName, prompt: Text("Name"))
                            .padding(.horizontal)
                        TextField("", text: $newAttributeType, prompt: Text("Type"))
                            .padding(.horizontal)
                        Button("Add") {
                            addAttribute()
                            withAnimation(.easeInOut) {
                                showAddAttribute.toggle()
                            }
                        }
                    }
                    AttributeRowView(attributes: $element.attributes)
                } header: {
                    HStack {
                        Text("Edit attributes")
                            .font(.title3)
                        Image(systemName: "plus")
                            .background(.clear)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showAddAttribute.toggle()
                                }
                            }
                    }
                }
                Section {
                    if showAddFunction {
                        Picker("", selection: $selectedAccessModifier) {
                            ForEach(OOPAccessModifier.allCases, id: \.self) { option in
                                Text(option.stringValue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        TextField("", text: $newFunctionName, prompt: Text("Name"))
                            .padding(.horizontal)
                        TextField("", text: $newFunctionReturnType, prompt: Text("Return Type"))
                            .padding(.horizontal)
                        TextEditor(text: $newFunctionBody)
                            .frame(height: 100)
                            .padding(.trailing)
                        Button("Add") {
                            addFunction()
                            withAnimation(.easeInOut) {
                                showAddFunction.toggle()
                            }
                        }
                    }
                    FunctionRowView(functions: $element.functions)
                } header: {
                    HStack {
                        Text("Edit functions")
                            .font(.title3)
                        Image(systemName: "plus")
                            .background(.clear)
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
    @Binding var attributes: [OOPElementAttribute]
    @State private var showEditor: Bool = false
    var body: some View {
        ForEach($attributes) { $attribute in
            VStack {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            attributes.removeAll { $0 == attribute }
                        }
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
}

struct FunctionRowView: View {
    @Binding var functions: [OOPElementFunction]
    @State private var showEditor: Bool = false
    var body: some View {
        ForEach($functions) { $function in
            VStack {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            functions.removeAll { $0 == function }
                        }
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
}
