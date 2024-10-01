//
//  Generalization.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 30..
//

import SwiftUI

struct Generalization: View, Connection {
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    
    var body: some View {
        let endPosition = getClosestEdgeCenter()
        Path() { path in
            path.move(to: startElement.position)
            path.addLine(to: endPosition)
        }
        .stroke(Color.black, lineWidth: 1)
        
        threeEdgeArrowHead(from: startElement.position, to: endPosition)
            .fill(Color.white)
            .stroke(Color.black, lineWidth: 1)
    }
}