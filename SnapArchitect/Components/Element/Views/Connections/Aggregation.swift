//
//  Aggregation.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 27..
//

import SwiftUI

struct Aggregation: View, Connection {
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    
    var body: some View {
        ZStack {
            let endPosition = getClosestEdgeCenter()
            Path { path in
                path.move(to: startElement.position)
                path.addLine(to: endPosition)
            }
            .stroke(Color.black, lineWidth: 1)
            
            DiamondShape()
                .fill(Color.white)
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 20, height: 8)
                .rotationEffect(Angle(degrees: angle(from: startElement.position, to: endPosition)))
                .position(endPosition)
        }
    }
}
