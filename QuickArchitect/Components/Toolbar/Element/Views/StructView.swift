//
//  StructView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct StructView: View {
    @Binding var representation: OOPElementRepresentation
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: representation.size.height * 0.3)
                    .border(Color.black, width: 1)
                VStack {
                    Text("<< struct >>")
                        .font(.caption)
                        .foregroundStyle(Color.black)
                    Text(representation.name)
                        .font(.caption)
                        .foregroundStyle(Color.black)
                }
            }
            Rectangle()
                .fill(.clear)
                .frame(height: representation.size.height * 0.7)
                .border(Color.black, width: 1)
        }
        .background(.white)
        .frame(width: representation.size.width)
        .overlay(
            // Draggable handle at the bottom-right corner
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 20, height: 20)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Update the size based on the drag amount
                            let newWidth = max(100, representation.size.width + value.translation.width)
                            let newHeight = max(50, representation.size.height + value.translation.height)
                            representation.size = CGSize(width: newWidth, height: newHeight)
                        }
                ),
            alignment: .bottomTrailing
        )
    }
}
