//
//  ClassView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ClassView: View {
    @Binding var representation: OOPElementRepresentation
    @State var backgroundColor: Color = .white
    var isSelected: Bool
    
    private var typeString: String {
        switch representation.type {
        case .classType:
            return "<< class >>"
        case .structType:
            return "<< struct >>"
        case .protocolType:
            return "<< protocol >>"
        case .enumType:
            return "<< enum >>"
        }
    }
    
    private func getAccessMofifier(_ access: OOPAccessModifier) -> String {
        switch access {
        case .accessInternal:
            return ""
        case .accessPublic:
            return "+"
        case .accessProtected:
            return "#"
        case .accessPrivate:
            return "-"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text(typeString)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Text(representation.name)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Divider()
                    .foregroundStyle(.black)
            }
            VStack {
                VStack(alignment: .leading) {
                    ForEach(representation.attributes) { attribute in
                        Text(
                            "\(getAccessMofifier(attribute.access)) \(attribute.name): \(attribute.type)"
                        )
                        .font(.caption2)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 12)
                    }
                    Divider()
                        .foregroundStyle(.black)
                }
                VStack(alignment: .leading) {
                    ForEach(representation.functions, id: \.id) { function in
                        DisclosureGroup(
                            "\(getAccessMofifier(function.access)) \(function.name): \(function.returnType)"
                        ) {
                            Text(function.functionBody)
                                .font(.caption2)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.caption2)
                    }
                }
            }
        }
        .frame(width: representation.size.width, height: representation.size.height, alignment: .top)
        .background(backgroundColor)
        .border(width: 1, edges: [.bottom, .top, .leading, .trailing], color: .black)
        .overlay(
            // Conditionally show the draggable handle
            Group {
                if isSelected {
                    Rectangle()
                        .fill(.accent.opacity(0.7))
                        .frame(width: 10, height: 10)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Update the size based on the drag amount
                                    let newWidth = max(100, representation.size.width + value.translation.width)
                                    let newHeight = max(50, representation.size.height + value.translation.height)
                                    representation.size = CGSize(width: newWidth, height: newHeight)
                                }
                        )
                }
            },
            alignment: .bottomTrailing
        )
        .shadow(radius: 10, x: 10, y: 10)
        .position(representation.position)
    }
}
