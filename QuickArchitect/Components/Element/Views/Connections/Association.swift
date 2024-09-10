//
//  Association.swift
//  QuickArchitect
//
//  Created by Anda Levente on 03/09/2024.
//

import SwiftUI

struct AssociationShape: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        var length = hypot(dx, dy)
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        return path
    }
}

struct Association: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Association()
}
