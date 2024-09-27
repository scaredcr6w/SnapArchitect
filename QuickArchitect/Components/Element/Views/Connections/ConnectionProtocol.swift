//
//  ConnectionProtocol.swift
//  QuickArchitect
//
//  Created by Anda Levente on 2024. 09. 27..
//

import Foundation

protocol Connection {
    var startElement: OOPElementRepresentation { get set }
    var endElement: OOPElementRepresentation { get set }
    
    func getEdgeCenters(
        elementPosition: CGPoint,
        elementSize: CGSize
    ) -> (top: CGPoint, bottom: CGPoint, leading: CGPoint, trailing: CGPoint)
    
    func getClosestEdgeCenter() -> CGPoint
}

extension Connection {
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
    
    /// Returns the connection endPoint's closest edge's center point
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
}
