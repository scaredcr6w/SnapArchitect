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
    var isSelected: Bool
    var body: some View {
        let endPostion = getClosestEdgeCenter()
        Path() { path in
            path.move(to: startElement.position)
            path.addLine(to: endPostion)
        }
        .stroke(Color.black, lineWidth: 1)
        .overlay(
            Group {
                if isSelected {
                    handleView
                        .position(getClosestEdgeCenter())
                }
            }
        )
    }
}
