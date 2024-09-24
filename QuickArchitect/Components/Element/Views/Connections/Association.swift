//
//  Association.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct Association: View {
    var startPoint: OOPElementRepresentation
    var endPoint: OOPElementRepresentation
    var body: some View {
        Path() { path in
            path.move(to: startPoint.position)
            path.addLine(to: endPoint.position)
        }
        .stroke(Color.black, lineWidth: 1)
    }
}
