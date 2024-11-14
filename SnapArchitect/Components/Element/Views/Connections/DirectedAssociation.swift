//
//  DirectedAssociation.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct DirectedAssociation: View, Connection {
    var connection: Binding<OOPConnectionRepresentation>
    
    var body: some View {
        let endPosition = getClosestEdgeCenter()
        ZStack {
            Path() { path in
                path.move(to: connection.startElement.wrappedValue.position)
                path.addLine(to: endPosition)
            }
            .stroke(Color.black, lineWidth: 1)
            
            twoEdgeArrowHead(from: connection.startElement.wrappedValue.position, to: endPosition)
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
