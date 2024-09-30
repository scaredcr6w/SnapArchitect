//
//  Dependency.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 30..
//

import SwiftUI

struct Dependency: View, Connection {
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    
    var body: some View {
        let endPosition = getClosestEdgeCenter()
        Path() { path in
            path.move(to: startElement.position)
            path.addLine(to: endPosition)
        }
        .stroke(style: .init(lineWidth: 1, dash: [20]))
        .foregroundStyle(.black)
        
        twoEdgeArrowHead(from: startElement.position, to: endPosition)
            .stroke(Color.black, lineWidth: 1)
    }
}
