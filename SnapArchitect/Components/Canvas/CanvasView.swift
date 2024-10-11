//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    @AppStorage("canvasBackgorundColor") private var backgroundColor: Color = .white
    @AppStorage("showGrid") private var showGrid: Bool = false
    @AppStorage("snapToGrid") private var snapToGrid: Bool = false
    @AppStorage("gridSize") private var gridSize: Double = 10
    @StateObject private var viewModel = CanvasViewModel()
    @Binding var document: SnapArchitectDocument
    @Binding var selectedTool: Any?
    @Binding var selectedElement: OOPElementRepresentation?
    
    private func updateConnections(for element: inout OOPElementRepresentation) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            for index in document.diagrams[diagramIndex].entityConnections.indices {
                if document.diagrams[diagramIndex].entityConnections[index].startElement.id == element.id {
                    document.diagrams[diagramIndex].entityConnections[index].startElement.position = element.position
                } else if document.diagrams[diagramIndex].entityConnections[index].endElement.id == element.id {
                    document.diagrams[diagramIndex].entityConnections[index].endElement.position = element.position
                }
            }
        }
    }
    
    private func addConnection(_ dragValue: DragGesture.Value) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            if let selectedTool = selectedTool as? OOPConnectionType {
                if let connection = viewModel.createConnection(
                    from: dragValue.startLocation,
                    to: dragValue.predictedEndLocation,
                    location: dragValue.location,
                    connectionType: selectedTool,
                    elements: document.diagrams[diagramIndex].entityRepresentations,
                    connections: document.diagrams[diagramIndex].entityConnections
                ) {
                    document.diagrams[diagramIndex].entityConnections.append(connection)
                    self.selectedTool = nil
                }
            }
        }
    }
    
    private func addElement(_ geo: GeometryProxy) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            if let selectedTool = selectedTool as? OOPElementType {
                if let newElement = viewModel.createElement(at: geo, selectedTool) {
                    document.diagrams[diagramIndex].entityRepresentations.append(newElement)
                    selectedElement = nil
                    self.selectedTool = nil
                }
            }
        }
        selectedElement = nil
    }
    
    @ViewBuilder
    private func drawElements() -> some View {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach($document.diagrams[diagramIndex].entityRepresentations) { $object in
                ClassView(
                    representation: $object,
                    isSelected: selectedElement?.id == object.id
                )
                .onTapGesture {
                    selectedElement = object
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if object.id == selectedElement?.id {
                                object.position = value.location
                                updateConnections(for: &object)
                            } else {
                                addConnection(value)
                            }
                        }
                        .onEnded { _ in
                            let snappedCorners = viewModel.getSnappedElementCorners(object, gridSize: gridSize)
                            viewModel.adjustPositionFromCorners(snappedCorners, element: &object)
                        }
                )
                .onChange(of: selectedElement) { _, newValue in
                    if let newValue = newValue {
                        if let index = document.diagrams[diagramIndex].entityRepresentations.firstIndex(where: { $0.id == newValue.id }) {
                            document.diagrams[diagramIndex].entityRepresentations[index] = newValue
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func drawConnections() -> some View {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach(document.diagrams[diagramIndex].entityConnections) { connection in
                if connection.type == .association {
                    Association(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .directedAssociation {
                    DirectedAssociation(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .composition {
                    Composition(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .aggregation {
                    Aggregation(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .dependency {
                    Dependency(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .generalization {
                    Generalization(startElement: connection.startElement, endElement: connection.endElement)
                } else if connection.type == .protocolRealization {
                    ProtocolRealization(startElement: connection.startElement, endElement: connection.endElement)
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ZStack {
                        if showGrid {
                            CanvasGridShape(gridSize: gridSize)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                        }
                        drawConnections()
                        drawElements()
                    }
                    .frame(width: geo.size.width * 3, height: geo.size.height * 3)
                }
                .background(backgroundColor)
                .background(GeometryReader { innerGeo in
                    Color.clear
                        .onAppear {
                            viewModel.updateScrollOffsets(geo: innerGeo)
                        }
                        .onChange(of: innerGeo.frame(in: .global)) {
                            viewModel.updateScrollOffsets(geo: innerGeo)
                        }
                })
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            addElement(geo)
                        }
                )
            }
            .scrollIndicators(.hidden)
        }
    }
}


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
