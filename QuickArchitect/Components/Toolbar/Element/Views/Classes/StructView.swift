//
//  StructView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct StructView: View {
    @Binding var representation: OOPElementRepresentation
    @Environment(\.openWindow) var openWindow
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("<< struct >>")
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Text(representation.name)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Divider()
                    .foregroundStyle(.black)
            }
            VStack {
                
                ForEach(representation.attributes, id: \.self) { attribute in
                    Text(attribute.name)
                        .font(.caption2)
                        .foregroundStyle(.black)
                }
                
                Divider()
                    .foregroundStyle(.black)
            }
            .frame(height: representation.size.height * 0.4)
            VStack {
                ForEach(representation.functions, id: \.id) { function in
                    DisclosureGroup(function.name) {
                        Text(function.functionBody)
                            .font(.caption2)
                            .foregroundStyle(.black)
                    }
                    .font(.caption2)
                    .foregroundStyle(.black)
                }
            }
            .frame(height: representation.size.height * 0.4)
        }
        .border(width: 1, edges: [.bottom, .top, .leading, .trailing], color: .black)
        .background(.white)
        .frame(width: representation.size.width)
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
    }
}
