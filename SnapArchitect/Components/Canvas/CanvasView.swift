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
    @StateObject private var zoomManager = ZoomManager()
    
    @ViewBuilder
    private func drawElements() -> some View {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach($document.diagrams[diagramIndex].entityRepresentations) { $object in
                ClassView(
                    representation: $object,
                    isSelected: $object.isSelected
                )
                .onTapGesture {
                    ToolManager.deselectAll(in: &document)
                    object.isSelected = true
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if object.isSelected {
                                object.position = value.location
                                viewModel.updateConnections(for: &object, in: &document)
                            } else {
                                viewModel.addConnection(to: &document, value) {
                                    ToolManager.selectedTool = nil
                                }
                            }
                        }
                        .onEnded { _ in
                            if snapToGrid {
                                let snappedCorners = viewModel.getSnappedElementCorners(object, gridSize: gridSize)
                                viewModel.adjustPositionFromCorners(snappedCorners, element: &object)
                            }
                        }
                )
                .onChange(of: document.diagrams[diagramIndex].entityRepresentations.first(where: { $0 == object })) { _, newValue in
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
            ForEach($document.diagrams[diagramIndex].entityConnections) { $connection in
                if connection.type == .association {
                    Association(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .directedAssociation {
                    DirectedAssociation(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .composition {
                    Composition(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .aggregation {
                    Aggregation(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .dependency {
                    Dependency(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .generalization {
                    Generalization(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
                    }
                } else if connection.type == .protocolRealization {
                    ProtocolRealization(
                        startElement: connection.startElement,
                        endElement: connection.endElement,
                        isSelected: connection.isSelected
                    )
                    .onTapGesture {
                        ToolManager.deselectAll(in: &document)
                        connection.isSelected = true
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
                    
                    if ToolManager.isDragging {
                        Rectangle()
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                            .background(Color.accentColor.opacity(0.2))
                            .frame(width: ToolManager.selectionRect.width, height: ToolManager.selectionRect.height)
                            .position(x: ToolManager.selectionRect.midX, y: ToolManager.selectionRect.midY)
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
                            if ToolManager.selectedTool != nil {
                                viewModel.createAndAddElement(
                                    to: &document,
                                    at: geo,
                                    ToolManager.selectedTool as? OOPElementType
                                ) {
                                    ToolManager.selectedTool = nil
                                }
                            } else {
                                ToolManager.deselectAll(in: &document)
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if ToolManager.dragStartLocation == nil {
                                ToolManager.dragStartLocation = value.startLocation
                                ToolManager.isDragging = true
                            }
                            
                            if let start = ToolManager.dragStartLocation {
                                let rect = CGRect(
                                    x: min(start.x, value.location.x),
                                    y: min(start.y, value.location.y),
                                    width: abs(start.x - value.location.x),
                                    height: abs(start.y - value.location.y)
                                )
                                
                                ToolManager.selectionRect = rect
                                ToolManager.dragSelection(with: rect, in: &document)
                            }
                        }
                        .onEnded { _ in
                            ToolManager.dragStartLocation = nil
                            ToolManager.isDragging = false
                        }
                )
            }
            .scrollIndicators(.hidden)
            .onHover { inside in
                if inside && ToolManager.selectedTool != nil {
                    NSCursor.crosshair.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}
