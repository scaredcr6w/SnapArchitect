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
    @State private var newAttributeName: String = ""
    @State private var newAttributeType: String = ""
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("", text: $element.name, prompt: Text(element.name))
                } header: {
                    Text("Edit name")
                }
                Section {
                    if showAddAttribute {
                        TextField("", text: $newAttributeName, prompt: Text("Name"))
                        TextField("", text: $newAttributeType, prompt: Text("Type"))
                        Button("Add") {
                            element.attributes.append(
                                OOPElementAttribute(
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
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showAddAttribute.toggle()
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    EditElementView(element: .constant(OOPElementRepresentation("Class 1", .classType, CGPoint(x: 100, y: 100), CGSize(width: 100, height: 150))))
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
                Divider()
                Text(attribute.type)
            }
            .frame(height: 50)
            HStack {
                if showEditor {
                    TextField("", text: $attribute.name, prompt: Text(attribute.name))
                    TextField("", text: $attribute.type, prompt: Text(attribute.type))
                }
            }
        }
    }
}

//#Preview {
//    AttributeRowView(attribute: .constant(OOPElementAttribute(name: "veryLongName", type: "String")))
//}

