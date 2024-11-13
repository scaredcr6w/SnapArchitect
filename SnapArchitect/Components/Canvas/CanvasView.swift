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
    @EnvironmentObject private var viewModel: CanvasViewModel
    @StateObject private var zoomManager = ZoomManager()
    
    private func handleDragGesture(_ element: Binding<OOPElementRepresentation>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if element.wrappedValue.isSelected {
                    element.wrappedValue.position = value.location
                    viewModel.updateConnections(for: &element.wrappedValue)
                } else {
                    viewModel.addConnection(value) {
                        ToolManager.shared.selectedTool = nil
                    }
                }
            }
            .onEnded { _ in
                if snapToGrid {
                    let snappedCorners = viewModel.getSnappedElementCorners(element.wrappedValue, gridSize: gridSize)
                    viewModel.adjustPositionFromCorners(snappedCorners, element: &element.wrappedValue)
                }
            }
    }
    
    private func handleEntityChange(newValue: OOPElementRepresentation, diagramIndex: Int) {
        if let index = viewModel.document.diagrams[diagramIndex].entityRepresentations.firstIndex(where: { $0.id == newValue.id }) {
            viewModel.document.diagrams[diagramIndex].entityRepresentations[index] = newValue
        }
    }
    
    @ViewBuilder
    private func drawElements() -> some View {
        if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach(viewModel.document.diagrams[diagramIndex].entityRepresentations.indices, id: \.self) { index in
                ElementView(element: $viewModel.document.diagrams[diagramIndex].entityRepresentations[index])
                    .onTapGesture {
                        viewModel.selectElement(element: &viewModel.document.diagrams[diagramIndex].entityRepresentations[index])
                    }
                    .gesture(
                        handleDragGesture(
                            $viewModel.document.diagrams[diagramIndex].entityRepresentations[index]
                        )
                    )
                    .onChange(of: viewModel.document.diagrams[diagramIndex].entityRepresentations[index]) { _, newValue in
                        handleEntityChange(newValue: newValue, diagramIndex: diagramIndex)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func drawConnections() -> some View {
        if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach(viewModel.document.diagrams[diagramIndex].entityConnections.indices, id: \.self) { index in
                var connection = viewModel.document.diagrams[diagramIndex].entityConnections[index]
                if connection.type == .association {
                    Association(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .directedAssociation {
                    DirectedAssociation(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .composition {
                    Composition(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .aggregation {
                    Aggregation(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .dependency {
                    Dependency(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .generalization {
                    Generalization(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                } else if connection.type == .protocolRealization {
                    ProtocolRealization(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    if showGrid {
                        CanvasGridShape(gridSize: gridSize)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    }
                    drawConnections()
                    drawElements()
                    
                    if ToolManager.shared.isDragging {
                        Rectangle()
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                            .background(Color.accentColor.opacity(0.2))
                            .frame(width: ToolManager.shared.selectionRect.width, height: ToolManager.shared.selectionRect.height)
                            .position(x: ToolManager.shared.selectionRect.midX, y: ToolManager.shared.selectionRect.midY)
                    }
                }
                .frame(width: geo.size.width * 3, height: geo.size.height * 3)
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
                            if ToolManager.shared.selectedTool != nil {
                                viewModel.createAndAddElement(
                                    at: geo,
                                    ToolManager.shared.selectedTool as? OOPElementType
                                ) {
                                    ToolManager.shared.selectedTool = nil
                                }
                            } else {
                                ToolManager.deselectAll()
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if ToolManager.shared.dragStartLocation == nil {
                                ToolManager.shared.dragStartLocation = value.startLocation
                                ToolManager.shared.isDragging = true
                            }
                            
                            if let start = ToolManager.shared.dragStartLocation {
                                let rect = CGRect(
                                    x: min(start.x, value.location.x),
                                    y: min(start.y, value.location.y),
                                    width: abs(start.x - value.location.x),
                                    height: abs(start.y - value.location.y)
                                )
                                
                                ToolManager.shared.selectionRect = rect
                                ToolManager.dragSelection(with: rect)
                            }
                        }
                        .onEnded { _ in
                            ToolManager.shared.dragStartLocation = nil
                            ToolManager.shared.isDragging = false
                        }
                )
            }
            .scrollIndicators(.hidden)
            .onHover { inside in
                if inside && ToolManager.shared.selectedTool != nil {
                    NSCursor.crosshair.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}

struct ElementView: View {
    @Binding var element: OOPElementRepresentation
    
    var body: some View {
        ClassView(representation: $element, isSelected: $element.isSelected)
    }
}
