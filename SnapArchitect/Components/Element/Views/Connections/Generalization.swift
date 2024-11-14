//
//  Generalization.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 30..
//

import SwiftUI

struct Generalization: View, Connection {
    var connection: Binding<OOPConnectionRepresentation>
    
    var body: some View {
        ZStack {
            let endPosition = getClosestEdgeCenter()
            Path() { path in
                path.move(to: connection.startElement.wrappedValue.position)
                path.addLine(to: endPosition)
            }
            .stroke(Color.black, lineWidth: 1)
            
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
