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
    
    @ViewBuilder
    private func drawElements() -> some View {
        ForEach($document.entityRepresentations) { $object in
            representationView($object)
                .position(object.position)
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
                                if let selectedTool = selectedTool as? OOPConnectionType {
                                    print(selectedTool)
                                    if let connection = viewModel.createConnection(
                                        from: value.startLocation,
                                        to: value.predictedEndLocation,
                                        location: value.location,
                                        connectionType: selectedTool,
                                        elements: document.entityRepresentations,
                                        connections: document.entityConnections
                                    ) {
                                        document.entityConnections.append(connection)
                                        self.selectedTool = nil
                                    }
                                }
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
            }
        }
    }
    
    @ViewBuilder
    private func representationView(_ representation: Binding<OOPElementRepresentation>) -> some View {
        ClassView(
            representation: representation,
            isSelected: selectedElement?.id == representation.id
        )
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ZStack {
                        drawElements()
                        drawConnections()
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
                            if selectedTool as? OOPElementType != nil {
                                if let newElement = viewModel.newElement(geo, selectedTool as? OOPElementType) {
                                    document.entityRepresentations.append(newElement)
                                    selectedElement = nil
                                    selectedTool = nil
                                }
                            }
                            selectedElement = nil
                        }
                )
            }
            .scrollIndicators(.hidden)
        }
    }
}
