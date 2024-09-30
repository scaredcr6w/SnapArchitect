//
//  ConnectionProtocol.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 27..
//

import Foundation
import SwiftUI

protocol Connection {
    var startElement: OOPElementRepresentation { get set }
    var endElement: OOPElementRepresentation { get set }
}

extension Connection {
    /// Gets a rectangle's edge's center points
    /// - Parameters:
    ///   - elementPosition: the position of the element
    ///   - elementSize: the size of the element
    /// - Returns: The four edge center points of a rectanle
    func getEdgeCenters(
        elementPosition: CGPoint,
        elementSize: CGSize
    ) -> (top: CGPoint, bottom: CGPoint, leading: CGPoint, trailing: CGPoint) {
        let leadingEdgeCenter = CGPoint(
            x: elementPosition.x - elementSize.width / 2,
            y: elementPosition.y
        )
        let trailingEdgeCenter = CGPoint(
            x: elementPosition.x + elementSize.width / 2,
            y: elementPosition.y
        )
        let topEdgeCenter = CGPoint(
            x: elementPosition.x,
            y: elementPosition.y - elementSize.height / 2
        )
        let bottomEdgeCenter = CGPoint(
            x: elementPosition.x,
            y: elementPosition.y + elementSize.height / 2
        )
        
        return (
            top: topEdgeCenter,
            bottom: bottomEdgeCenter,
            leading: leadingEdgeCenter,
            trailing: trailingEdgeCenter
        )
    }
    
    /// Gets the connection endPoint's closest edge's center point
    /// - Returns: The CGPoint of the endPoint's closest edge's center point
    func getClosestEdgeCenter() -> CGPoint {
        let endElementEdgeCenter = getEdgeCenters(elementPosition: endElement.position, elementSize: endElement.size)
        
        let referencePoint = startElement.position
        
        let topDistance = distance(from: endElementEdgeCenter.top, to: referencePoint)
        let bottomDistance = distance(from: endElementEdgeCenter.bottom, to: referencePoint)
        let leadingDistance = distance(from: endElementEdgeCenter.leading, to: referencePoint)
        let trailingDistance = distance(from: endElementEdgeCenter.trailing, to: referencePoint)
        
        let minDistance = min(topDistance, bottomDistance, leadingDistance, trailingDistance)
        
        switch minDistance {
        case topDistance:
            return endElementEdgeCenter.top
        case bottomDistance:
            return endElementEdgeCenter.bottom
        case leadingDistance:
            return endElementEdgeCenter.leading
        case trailingDistance:
            return endElementEdgeCenter.trailing
        default:
            return endElementEdgeCenter.top
        }
    }
    
    func twoEdgeArrowHead(from startPoint: CGPoint, to endPoint: CGPoint) -> Path {
        Path { path in
            let arrowLength: CGFloat = 15.0
            let arrowAngle: CGFloat = .pi / 6
            
            let dx = endPoint.x - startPoint.x
            let dy = endPoint.y - startPoint.y
            let angle = atan2(dy, dx)
            
            let arrowLeft = CGPoint(
                x: endPoint.x - arrowLength * cos(angle - arrowAngle),
                y: endPoint.y - arrowLength * sin(angle - arrowAngle)
            )
            let arrowRight = CGPoint(
                x: endPoint.x - arrowLength * cos(angle + arrowAngle),
                y: endPoint.y - arrowLength * sin(angle + arrowAngle)
            )
            
            path.move(to: arrowLeft)
            path.addLine(to: endPoint)
            path.addLine(to: arrowRight)
        }
    }
    
    func threeEdgeArrowHead(from startPoint: CGPoint, to endPoint: CGPoint) -> Path {
        Path { path in
            let arrowLength: CGFloat = 15.0
            let arrowAngle: CGFloat = .pi / 6
            
            let dx = endPoint.x - startPoint.x
            let dy = endPoint.y - startPoint.y
            let angle = atan2(dy, dx)
            
            let arrowLeft = CGPoint(
                x: endPoint.x - arrowLength * cos(angle - arrowAngle),
                y: endPoint.y - arrowLength * sin(angle - arrowAngle)
            )
            let arrowRight = CGPoint(
                x: endPoint.x - arrowLength * cos(angle + arrowAngle),
                y: endPoint.y - arrowLength * sin(angle + arrowAngle)
            )
            
            path.move(to: arrowLeft)
            path.addLine(to: endPoint)
            path.addLine(to: arrowRight)
            path.addLine(to: arrowLeft)
        }
    }
    
    /// Calculates distance between two points
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: The distance between the points in CGFloat
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        
        return sqrt(pow(xDist, 2) + pow(yDist, 2))
    }
    
    /// Calculates the angle between two points
    /// - Parameters:
    ///   - point1: the first point
    ///   - point2: the second point
    /// - Returns: the angle between two points
    func angle(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let radians = atan2(dy, dx)
        let degrees = radians * 180 / .pi
        
        return degrees
    }
}
