//
//  EditElementView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 09/09/2024.
//

import SwiftUI

struct EditElementView: View {
    @StateObject var viewModel: EditElementViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            Text("Edit Element")
                .font(.title3)
                .foregroundStyle(.gray)
            Divider()
            
            Form {
                Section {
                    TextField("", text: $viewModel.element.name, prompt: Text(viewModel.element.name))
                        .padding(.horizontal)
                        .focusing($isTextFieldFocused) { focused in
                            viewModel.focusTextField(focused)
                        }
                } header: {
                    Text("Edit name")
                        .font(.title3)
                }
                Section {
                    if viewModel.showAddAttribute {
                        Picker("", selection: $viewModel.selectedAccessModifier) {
                            ForEach(OOPAccessModifier.allCases, id: \.self) { option in
                                Text(option.stringValue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        TextField("", text: $viewModel.newAttributeName, prompt: Text("Name"))
                            .padding(.horizontal)
                            .focusing($isTextFieldFocused) { focused in
                                viewModel.focusTextField(focused)
                            }
                        TextField("", text: $viewModel.newAttributeType, prompt: Text("Type"))
                            .padding(.horizontal)
                            .focusing($isTextFieldFocused) { focused in
                                viewModel.focusTextField(focused)
                            }
                        Button("Add") {
                            viewModel.addAttribute()
                            withAnimation(.easeInOut) {
                                viewModel.showAddAttribute.toggle()
                            }
                        }
                    }
                    AttributeRowView(viewModel: viewModel)
                } header: {
                    HStack {
                        Text("Edit attributes")
                            .font(.title3)
                        Image(systemName: "plus")
                            .background(.clear)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.showAddAttribute.toggle()
                                }
                            }
                    }
                }
                Section {
                    if viewModel.showAddFunction {
                        Picker("", selection: $viewModel.selectedAccessModifier) {
                            ForEach(OOPAccessModifier.allCases, id: \.self) { option in
                                Text(option.stringValue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        TextField("", text: $viewModel.newFunctionName, prompt: Text("Name"))
                            .padding(.horizontal)
                            .focusing($isTextFieldFocused) { focused in
                                viewModel.focusTextField(focused)
                            }
                        TextField("", text: $viewModel.newFunctionReturnType, prompt: Text("Return Type"))
                            .padding(.horizontal)
                            .focusing($isTextFieldFocused) { focused in
                                viewModel.focusTextField(focused)
                            }
                        TextEditor(text: $viewModel.newFunctionBody)
                            .frame(height: 100)
                            .padding(.trailing)
                            .focusing($isTextFieldFocused) { focused in
                                viewModel.focusTextField(focused)
                            }
                        Button("Add") {
                            viewModel.addFunction()
                            withAnimation(.easeInOut) {
                                viewModel.showAddFunction.toggle()
                            }
                        }
                    }
                    FunctionRowView(viewModel: viewModel)
                } header: {
                    HStack {
                        Text("Edit functions")
                            .font(.title3)
                        Image(systemName: "plus")
                            .background(.clear)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.showAddFunction.toggle()
                                }
                            }
                    }
                }
                
            }
            .onDisappear {
                ToolManager.shared.isEditing = false
            }
            .alert("Error", isPresented: $viewModel.didError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred.")
            }
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    struct AttributeRowView: View {
        @StateObject var viewModel: EditElementViewModel
        @State private var showEditor: Bool = false
        @FocusState private var isTextFieldFocused: Bool
        
        var body: some View {
            ScrollView {
                ForEach($viewModel.element.attributes) { $attribute in
                    VStack {
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .padding(.horizontal, 5)
                                .onTapGesture {
                                    viewModel.removeAttribute(attribute)
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
                                    .focusing($isTextFieldFocused) { focused in
                                        viewModel.focusTextField(focused)
                                    }
                                TextField("", text: $attribute.type)
                                    .focusing($isTextFieldFocused) { focused in
                                        viewModel.focusTextField(focused)
                                    }
                            }
                        }
                        .frame(maxHeight: showEditor ? .none : 0)
                        .opacity(showEditor ? 1 : 0)
                        .animation(.easeInOut, value: showEditor)
                    }
                }
            }
        }
    }

    struct FunctionRowView: View {
        @StateObject var viewModel: EditElementViewModel
        @State private var showEditor: Bool = false
        @FocusState private var isTextFieldFocused: Bool
        
        var body: some View {
            ScrollView {
                ForEach($viewModel.element.functions) { $function in
                    VStack {
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .padding(.horizontal, 5)
                                .onTapGesture {
                                    viewModel.removeFunction(function)
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
                                    .focusing($isTextFieldFocused) { focused in
                                        viewModel.focusTextField(focused)
                                    }
                                TextField("", text: $function.returnType)
                                    .focusing($isTextFieldFocused) { focused in
                                        viewModel.focusTextField(focused)
                                    }
                                TextEditor(text: $function.functionBody)
                                    .frame(height: 100)
                                    .focusing($isTextFieldFocused) { focused in
                                        viewModel.focusTextField(focused)
                                    }
                            }
                        }
                        .frame(maxHeight: showEditor ? .none : 0)
                        .opacity(showEditor ? 1 : 0)
                        .animation(.easeInOut, value: showEditor)
                    }
                }
            }
        }
    }

}

