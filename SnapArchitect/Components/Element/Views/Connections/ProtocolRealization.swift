//
//  ProtocolRealization.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 30..
//

import SwiftUI

struct ProtocolRealization: View, Connection {
    var connection: Binding<OOPConnectionRepresentation>
    
    var body: some View {
        ZStack {
            let endPosition = getClosestEdgeCenter()
            Path() { path in
                path.move(to: connection.startElement.wrappedValue.position)
                path.addLine(to: endPosition)
            }
            .stroke(style: .init(lineWidth: 1, dash: [20]))
            .foregroundStyle(.black)
            
            threeEdgeArrowHead(from: connection.startElement.wrappedValue.position, to: endPosition)
                .fill(Color.white)
                .stroke(Color.black, lineWidth: 1)
        }
        .overlay(
            Group {
                if connection.wrappedValue.isSelected {
                    handleView
                        .position(getClosestEdgeCenter())
                }
            }
        )
    }
}
