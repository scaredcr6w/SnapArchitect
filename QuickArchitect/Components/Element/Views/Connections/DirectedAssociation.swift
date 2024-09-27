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
        Path() { path in
            let endPosition = getClosestEdgeCenter()
            path.move(to: startElement.position)
            path.addLine(to: endPosition)
            
            addArrowHead(to: &path, from: startElement.position, to: endPosition)
        }
        .stroke(Color.black, lineWidth: 1)
    }
    
    // Function to add an arrowhead at the end of the line
    func addArrowHead(to path: inout Path, from startPoint: CGPoint, to endPoint: CGPoint) {
        // Calculate the vector from start to end
        let arrowLength: CGFloat = 15.0 // Length of arrowhead lines
        let arrowAngle: CGFloat = .pi / 6 // Angle for arrowhead (30 degrees)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let angle = atan2(dy, dx)
        
        // Calculate points for arrowhead
        let arrowLeft = CGPoint(
            x: endPoint.x - arrowLength * cos(angle - arrowAngle),
            y: endPoint.y - arrowLength * sin(angle - arrowAngle)
        )
        let arrowRight = CGPoint(
            x: endPoint.x - arrowLength * cos(angle + arrowAngle),
            y: endPoint.y - arrowLength * sin(angle + arrowAngle)
        )
        
        // Draw arrowhead
        path.move(to: arrowLeft)
        path.addLine(to: endPoint)
        path.addLine(to: arrowRight)
    }
}
