//
//  Association.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct Association: View {
    let startPoint: CGPoint
    let endPoint: CGPoint
    var body: some View {
        Path() { path in
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        .stroke(Color.black, lineWidth: 3)
    }
}
