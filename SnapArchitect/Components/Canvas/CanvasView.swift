//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    @StateObject var viewModel: CanvasViewModel
    @StateObject private var zoomManager = ZoomManager()
    
    @ViewBuilder
    private func drawElements() -> some View {
        if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach($viewModel.document.diagrams[diagramIndex].entityRepresentations, id: \.id) { $element in
                let classViewModel = ClassViewModel(element, viewModel.document, viewModel.documentProxy)
                ClassView(viewModel: classViewModel)
                    .onTapGesture {
                        viewModel.selectElement(element: &element)
                    }
                    .gesture(
                        viewModel.handleDragGesture($element)
                    )
                    .onChange(of: element) { _, newValue in
                        viewModel.handleEntityChange(newValue: newValue, diagramIndex: diagramIndex)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func createConnectionView(_ connection: Binding<OOPConnectionRepresentation>) -> some View {
        switch connection.wrappedValue.type {
        case .association:
            Association(connection: connection)
        case .directedAssociation:
            DirectedAssociation(connection: connection)
        case .aggregation:
            Aggregation(connection: connection)
        case .composition:
            Composition(connection: connection)
        case .dependency:
            Dependency(connection: connection)
        case .generalization:
            Generalization(connection: connection)
        case .protocolRealization:
            ProtocolRealization(connection: connection)
        }
    }
    
    @ViewBuilder
    private func drawConnections() -> some View {
        if let diagramIndex = viewModel.document.diagrams.firstIndex(where: { $0.isSelected }) {
            ForEach($viewModel.document.diagrams[diagramIndex].entityConnections, id: \.id) { $connection in
                createConnectionView($connection)
                    .onTapGesture {
                        viewModel.selectConnection(connection: &connection)
                    }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    if viewModel.showGrid {
                        CanvasGridShape(gridSize: viewModel.gridSize)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    }
                    drawConnections()
                    drawElements()
                    
                    if viewModel.isDraging {
                        Rectangle()
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                            .background(Color.accentColor.opacity(0.2))
                            .frame(width: viewModel.selectionRect.width, height: viewModel.selectionRect.height)
                            .position(x: viewModel.selectionRect.midX, y: viewModel.selectionRect.midY)
                    }
                }
                .frame(width: geo.size.width * 3, height: geo.size.height * 3)
                .background(viewModel.backgroundColor)
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
                                let clickLocation = viewModel.getCurrentClickLocation(geo: geo)
                                viewModel.newElement(at: clickLocation)
                            } else {
                                viewModel.deselectAll()
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.startDragSelection(value)
                        }
                        .onEnded { _ in
                            viewModel.endDragSelection()
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
