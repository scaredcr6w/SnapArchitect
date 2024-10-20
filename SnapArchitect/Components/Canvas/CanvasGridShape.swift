//
//  CanvasGridShape.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 16..
//

import SwiftUI

struct CanvasGridShape: Shape {
    var gridSize: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for x in stride(from: 0, to: rect.width, by: gridSize) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, to: rect.height, by: gridSize) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

