//
//  Association.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct Association: View, Connection {
    var startElement: OOPElementRepresentation
    var endElement: OOPElementRepresentation
    var body: some View {
        Path() { path in
            path.move(to: startElement.position)
            path.addLine(to: getClosestEdgeCenter())
        }
        .stroke(Color.black, lineWidth: 1)
    }
}
