//
//  CanvasTests.swift
//  CanvasTests
//
//  Created by Anda Levente on 2024. 09. 26..
//

import Foundation
import Testing
@testable import Snap_Architect
import AppKit

class CanvasTests {
    @Suite("Connection tests") struct ConnectionTests {
        let documentProxy = MockDocumentProxy()
        
        @Test("Test distance between 2 points") func testDistance() {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            let point1 = CGPoint(x: 10, y: 10)
            let point2 = CGPoint(x: 20, y: 20)
            #expect(viewModel.distance(from: point1, to: point2) == 14.142135623730951)
        }
        
        @Test("Find the closest element to a given point") func testFindClosestElement() throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                let firstElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                
                #expect(viewModel.findClosestElement(to: CGPoint(x: 0, y: 0), viewModel.document.diagrams[diagramIndex].entityRepresentations) == firstElement)
            }
        }
        
        @Test("Check if connection exists") func testCheckIfConnectionExists() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                let startElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let endElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                viewModel.document.diagrams[diagramIndex].entityConnections.append(
                    OOPConnectionRepresentation(
                        type: .association,
                        startElement: startElement,
                        endElement: endElement
                    )
                )
                
                #expect(viewModel.checkIfConnectionExists(startElement, endElement))
            }
        }
        
        @Test("Check if connection exists reversed") func testCheckIfConnectionExistsReverse() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                let startElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let endElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                viewModel.document.diagrams[diagramIndex].entityConnections.append(
                    OOPConnectionRepresentation(
                        type: .association,
                        startElement: endElement,
                        endElement: startElement
                    )
                )
                
                #expect(viewModel.checkIfConnectionExists(startElement, endElement))
            }
        }
        
        @Test("Check if connection doesn't exist") func testCheckIfConnectionExistsFalse() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                let startElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let endElement = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                #expect(!viewModel.checkIfConnectionExists(startElement, endElement))
            }
        }
        
        @Test("Create connection") func testCreateConnection() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                ToolManager.shared.selectedTool = .association as OOPConnectionType
                
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                viewModel.newConnection(
                    from: CGPoint(x: 8, y: 8),
                    to: CGPoint(x: 24, y: 28),
                    location: CGPoint(x: 22, y: 33)
                )
                
                #expect(viewModel.document.diagrams[diagramIndex].entityConnections.count == 1)
            }
        }
        
        @Test("Points are too far to create connection") func testCreateConnectionPointsTooFar() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 10, y: 10),
                        CGSize(width: 100, height: 100))
                )
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(
                    OOPElementRepresentation(
                        .accessPublic,
                        "Class1",
                        .classType,
                        CGPoint(x: 20, y: 30),
                        CGSize(width: 100, height: 100))
                )
                
                ToolManager.shared.selectedTool = .association as OOPConnectionType
                
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                viewModel.newConnection(
                    from: CGPoint(x: 8, y: 8),
                    to: CGPoint(x: 24, y: 28),
                    location: CGPoint(x: 10, y: 10)
                )
                
                #expect(viewModel.document.diagrams[diagramIndex].entityConnections.isEmpty)
            }
        }
        
        @Test("Connection updates when connected start element moves") func testUpdateConnectionForStartElement() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            var startElement = OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 10, y: 10),
                CGSize(width: 100, height: 100)
            )
            let endElement = OOPElementRepresentation(
                .accessPublic,
                "Class1",
                .classType,
                CGPoint(x: 20, y: 30),
                CGSize(width: 100, height: 100)
            )
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(startElement)
                viewModel.document.diagrams[diagramIndex].entityRepresentations.append(endElement)
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.first)
                let _ = try #require(viewModel.document.diagrams[diagramIndex].entityRepresentations.last)
                
                viewModel.newConnection(
                    from: CGPoint(x: 10, y: 10),
                    to: CGPoint(x: 20, y: 30),
                    location: CGPoint(x: 20, y: 30)
                )
                
                startElement.position = CGPoint(x: 100, y: 100)
                
                viewModel.updateConnections(for: &startElement)
                #expect(
                    viewModel.document.diagrams[diagramIndex].entityConnections.first?.startElement.position == CGPoint(x: 100, y: 100)
                )
            }
        }
    }
    
    @Suite("Element tests") struct ElementTests {
        let documentProxy = MockDocumentProxy()
        
        @Test("Mouse click position")
        func testMouseClickPosition() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            let geoSize = CGSize(width: 100, height: 100)
            let mockEvent = NSEvent.mouseEvent(
                with: .leftMouseDown,
                location: CGPoint(x: 50, y: 50),
                modifierFlags: [],
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                eventNumber: 0,
                clickCount: 1,
                pressure: 1.0
            )!
            
            #expect(viewModel.getMouseClick(geoSize, event: mockEvent) == CGPoint(x: 50, y: 50))
        }
        
        @Test("Mouse click outside of canvas")
        func testMouseClickOutsideCanvas() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            let geoSize = CGSize(width: 100, height: 100)
            let mockEvent = NSEvent.mouseEvent(
                with: .leftMouseDown,
                location: CGPoint(x: -1, y: -1),
                modifierFlags: [],
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                eventNumber: 0,
                clickCount: 1,
                pressure: 1.0
            )!
            
            #expect(viewModel.getMouseClick(geoSize, event: mockEvent) == .zero)
        }
        
        @Test("Invalid canvas geometry")
        func testInvalidCanvasGeometry() async throws {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            let geoSize = CGSize(width: -1, height: -1)
            let mockEvent = NSEvent.mouseEvent(
                with: .leftMouseDown,
                location: CGPoint(x: 1, y: 1),
                modifierFlags: [],
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                eventNumber: 0,
                clickCount: 1,
                pressure: 1.0
            )!
            
            #expect(viewModel.getMouseClick(geoSize, event: mockEvent) == .zero)
        }
        
        @Test("Test element creation")
        func testNewElement() {
            let viewModel = CanvasViewModel(SnapArchitectDocument(), documentProxy)
            
            if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
                ToolManager.shared.selectedTool = .protocolType as OOPElementType
                
                viewModel.newElement(
                    at: CGPoint(x: 10, y: 10)
                )
                
                #expect(viewModel.document.diagrams[diagramIndex].entityRepresentations.count == 1)
            }
        }
    }
}
