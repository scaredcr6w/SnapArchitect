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
                                if let connection = viewModel.createConnection(
                                    from: value.startLocation,
                                    to: value.predictedEndLocation,
                                    location: value.location,
                                    elements: document.entityRepresentations
                                ) {
                                    object.connections.append(connection)
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
        ForEach(document.entityRepresentations) { entity in
            ForEach(entity.connections) { connection in
                Association(startPoint: connection.startElement, endPoint: connection.endElement)
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
    
#warning("Problema: ha az element egy endPoint, akkor nem mozgatható a connection, mert nincs benne a saját connections listajaban, ezert atugorja a for ciklust")
    private func updateConnections(for element: inout OOPElementRepresentation) {
        for index in element.connections.indices {
            if element.connections[index].startElement.id == element.id {
                element.connections[index].startElement.position = element.position
            } else if element.connections[index].endElement.id == element.id {
                element.connections[index].endElement.position = element.position
            }
        }
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
                        }
                )
            }
            .scrollIndicators(.hidden)
        }
    }
}
