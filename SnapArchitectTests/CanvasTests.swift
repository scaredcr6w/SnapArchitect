//
//  CanvasTests.swift
//  CanvasTests
//
//  Created by Anda Levente on 2024. 09. 26..
//

import Foundation
import Testing
@testable import Snap_Architect

class CanvasTests {
    let viewModel = CanvasViewModel()
    
    @Test("Test distance between 2 points") func testDistance() {
        let point1 = CGPoint(x: 10, y: 10)
        let point2 = CGPoint(x: 20, y: 20)
        #expect(viewModel.distance(from: point1, to: point2) == 14.142135623730951)
    }
    
    @Test("Find the closest element to a given point") func testFindClosestElement() throws {
        var document = QuickArchitectDocument()
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let firstElement = try #require(document.entityRepresentations.first)
        
        #expect(viewModel.findClosestElement(to: CGPoint(x: 0, y: 0), document.entityRepresentations) == firstElement)
    }
    
    @Test("Check if connection exists") func testCheckIfConnectionExists() async throws {
        var document = QuickArchitectDocument()
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let startElement = try #require(document.entityRepresentations.first)
        let endElement = try #require(document.entityRepresentations.last)
        
        document.entityConnections.append(
            OOPConnectionRepresentation(
                type: .association,
                startElement: startElement,
                endElement: endElement
            )
        )
        
        #expect(viewModel.checkIfConnectionExists(startElement, endElement, document.entityConnections))
    }
    
    @Test("Check if connection exists reversed") func testCheckIfConnectionExistsReverse() async throws {
        var document = QuickArchitectDocument()
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let startElement = try #require(document.entityRepresentations.first)
        let endElement = try #require(document.entityRepresentations.last)
        
        document.entityConnections.append(
            OOPConnectionRepresentation(
                type: .association,
                startElement: endElement,
                endElement: startElement
            )
        )
        
        #expect(viewModel.checkIfConnectionExists(startElement, endElement, document.entityConnections))
    }
    
    @Test("Check if connection doesn't exist") func testCheckIfConnectionExistsFalse() async throws {
        var document = QuickArchitectDocument()
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let startElement = try #require(document.entityRepresentations.first)
        let endElement = try #require(document.entityRepresentations.last)
        
        #expect(viewModel.checkIfConnectionExists(startElement, endElement, document.entityConnections) == false)
    }
    
    @Test("Create connection") func testCreateConnection() async throws {
        var document = QuickArchitectDocument()
        
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let startElement = try #require(document.entityRepresentations.first)
        let endElement = try #require(document.entityRepresentations.last)
        
        let connection = try #require(
            viewModel.createConnection(
                from: CGPoint(x: 8, y: 8),
                to: CGPoint(x: 24, y: 28),
                location: CGPoint(x: 22, y: 33),
                connectionType: .association,
                elements: document.entityRepresentations, connections: document.entityConnections
            )
        )
        
        #expect(connection.startElement == startElement && connection.endElement == endElement)
    }
    
    @Test("Points are too far to create connection") func testCreateConnectionPointsTooFar() async throws {
        var document = QuickArchitectDocument()
        
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100))
        )
        document.entityRepresentations.append(
            OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100))
        )
        let _ = try #require(document.entityRepresentations.first)
        let _ = try #require(document.entityRepresentations.last)
        
        let connection = viewModel.createConnection(
            from: CGPoint(x: 8, y: 8),
            to: CGPoint(x: 24, y: 28),
            location: CGPoint(x: 10, y: 10),
            connectionType: .association,
            elements: document.entityRepresentations, connections: document.entityConnections
        )
        
        #expect(connection == nil)
    }
}
