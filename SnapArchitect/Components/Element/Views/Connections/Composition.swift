//
//  Composition.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 27..
//

import SwiftUI

struct Composition: View, Connection {
    var connection: Binding<OOPConnectionRepresentation>
    
    var body: some View {
        ZStack {
            let endPosition = getClosestEdgeCenter()
            Path { path in
                path.move(to: connection.startElement.wrappedValue.position)
                path.addLine(to: endPosition)
            }
            .stroke(Color.black, lineWidth: 1)
            
            DiamondShape()
                .fill(Color.black)
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 20, height: 8)
                .rotationEffect(Angle(degrees: angle(from: connection.startElement.wrappedValue.position, to: endPosition)))
                .position(endPosition)
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


