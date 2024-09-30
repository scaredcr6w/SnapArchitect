//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    @StateObject private var viewModel = CanvasViewModel()
    @Binding var document: QuickArchitectDocument
    @Binding var selectedTool: Any?
    @Binding var selectedElement: OOPElementRepresentation?
    
    private func updateConnections(for element: inout OOPElementRepresentation) {
        for index in document.entityConnections.indices {
            if document.entityConnections[index].startElement.id == element.id {
                document.entityConnections[index].startElement.position = element.position
            } else if document.entityConnections[index].endElement.id == element.id {
                document.entityConnections[index].endElement.position = element.position
            }
        }
    }
    
    private func addConnection(_ dragValue: DragGesture.Value) {
        if let selectedTool = selectedTool as? OOPConnectionType {
            if let connection = viewModel.createConnection(
                from: dragValue.startLocation,
                to: dragValue.predictedEndLocation,
                location: dragValue.location,
                connectionType: selectedTool,
                elements: document.entityRepresentations,
                connections: document.entityConnections
            ) {
                document.entityConnections.append(connection)
                self.selectedTool = nil
            }
        }
    }
    
    private func addElement(_ geo: GeometryProxy) {
        if let selectedTool = selectedTool as? OOPElementType {
            if let newElement = viewModel.createElement(at: geo, selectedTool) {
                document.entityRepresentations.append(newElement)
                selectedElement = nil
                self.selectedTool = nil
            }
        }
        selectedElement = nil
    }
    
    @ViewBuilder
    private func drawElements() -> some View {
        ForEach($document.entityRepresentations) { $object in
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
            )
            .onChange(of: selectedElement) { _, newValue in
                if let newValue = newValue {
                    if let index = document.entityRepresentations.firstIndex(where: { $0.id == newValue.id }) {
                        document.entityRepresentations[index] = newValue
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func drawConnections() -> some View {
        ForEach(document.entityConnections) { connection in
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

    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ZStack {
                        drawConnections()
                        drawElements()
                    }
                    .frame(width: geo.size.width * 3, height: geo.size.height * 3)
                }
                .background(.white)
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
