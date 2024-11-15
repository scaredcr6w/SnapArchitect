//
//  CanvasViewModel+CornerSnapping.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 15..
//

import Foundation

extension CanvasViewModel {
    func snapToGrid(
        _ point: CGPoint,
        gridSize: Double
    ) -> CGPoint {
        let snappedX = round(point.x / gridSize) * gridSize
        let snappedY = round(point.y / gridSize) * gridSize
        return CGPoint(x: snappedX, y: snappedY)
    }
    
    func getSnappedElementCorners(
        _ element: OOPElementRepresentation,
        gridSize: Double
    ) -> (
        topLeft: CGPoint,
        bottomLeft: CGPoint,
        bottomRight: CGPoint,
        topRight: CGPoint
    ) {
        let center = snapToGrid(element.position, gridSize: gridSize)
        
        let tLeft = snapToGrid(CGPoint(x: center.x - element.size.width / 2, y: center.y - element.size.height / 2), gridSize: gridSize)
        let bLeft = snapToGrid(CGPoint(x: center.x - element.size.width / 2, y: center.y + element.size.height / 2), gridSize: gridSize)
        let tRight = snapToGrid(CGPoint(x: center.x + element.size.width / 2, y: center.y - element.size.height / 2), gridSize: gridSize)
        let bRight = snapToGrid(CGPoint(x: center.x + element.size.width / 2, y: center.y + element.size.height / 2), gridSize: gridSize)
        
        return (topLeft: tLeft, bottomLeft: bLeft, bottomRight: bRight, topRight: tRight)
    }
    
    func adjustPositionFromCorners(
        _ corners: (
            topLeft: CGPoint,
            bottomLeft: CGPoint,
            bottomRight: CGPoint,
            topRight: CGPoint
        ),
        element: inout OOPElementRepresentation
    ) {
        let centerX = (corners.topLeft.x + corners.bottomRight.x) / 2
        let centerY = (corners.topLeft.y + corners.bottomRight.y) / 2
        let newPosition = CGPoint(x: centerX, y: centerY)
        
        element.position = newPosition
    }
}
