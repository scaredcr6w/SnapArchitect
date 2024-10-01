//
//  DirectedAssociation.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct DirectedAssociation: View, Connection {
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    
    var body: some View {
        let endPosition = getClosestEdgeCenter()
        Path() { path in
            path.move(to: startElement.position)
            path.addLine(to: endPosition)
        }
        .stroke(Color.black, lineWidth: 1)
        
        twoEdgeArrowHead(from: startElement.position, to: endPosition)
            .stroke(Color.black, lineWidth: 1)
    }
}
