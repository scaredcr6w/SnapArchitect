//
//  ProtocolView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ProtocolView: View {
    @Binding var representation: OOPElementRepresentation
    @Environment(\.openWindow) var openWindow
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(.clear)
                .stroke(.black, lineWidth: 1)
                .frame(height: representation.size.height * 0.3)
            Text(representation.name)
                .font(.caption)
                .foregroundStyle(Color.black)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.black)
        }
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
