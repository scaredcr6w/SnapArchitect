//
//  Association.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct Association: View, Connection {
    var connection: Binding<OOPConnectionRepresentation>
    
    var body: some View {
        let endPostion = getClosestEdgeCenter()
        Path() { path in
            path.move(to: connection.startElement.wrappedValue.position)
            path.addLine(to: endPostion)
        }
        .stroke(Color.black, lineWidth: 1)
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
