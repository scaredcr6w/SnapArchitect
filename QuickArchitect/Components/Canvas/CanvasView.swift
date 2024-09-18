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
    
    @State var connectionStartElement: OOPElementRepresentation? = nil
    @State var connectionEndElement: OOPElementRepresentation? = nil
    
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
                            } else {
                                connectionStartElement = viewModel.findClosestElement(to: value.startLocation, document.entityRepresentations)
                            }
                        }
                        .onEnded { value in
                            #warning("TODO: Refactor mert ez nagyon ocsmany")
                            connectionEndElement = viewModel.findClosestElement(to: value.location, document.entityRepresentations)
                            newConnection()
                            
//                            if let startElement = connectionStartElement, let endElement = connectionEndElement {
//                                if let selectedTool = selectedTool as? OOPConnectionType {
//                                    document.entityConnections.append(
//                                        OOPConnectionRepresentation(
//                                            selectedTool,
//                                            viewModel.getEdgeCenters(
//                                                elementPosition: startElement.position,
//                                                elementSize: startElement.size
//                                            ).trailing,
//                                            viewModel.getEdgeCenters(
//                                                elementPosition: endElement.position,
//                                                elementSize: endElement.size
//                                            ).leading
//                                        )
//                                    )
//                                }
//                            }
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
    private func representationView(_ representation: Binding<OOPElementRepresentation>) -> some View {
        ClassView(
            representation: representation,
            isSelected: selectedElement?.id == representation.id
        )
    }
    
    @ViewBuilder
    private func drawConnections() -> some View {
        ForEach(document.entityConnections) { connetion in
            Association(startPoint: connetion.startPoint, endPoint: connetion.endPoint)
        }
    }
    
    private func newConnection() {
        if let startElement = connectionStartElement, let endElement = connectionEndElement {
            if let selectedTool = selectedTool as? OOPConnectionType {
                document.entityConnections.append(
                    OOPConnectionRepresentation(
                        selectedTool,
                        viewModel.getEdgeCenters(
                            elementPosition: startElement.position,
                            elementSize: startElement.size
                        ).trailing,
                        viewModel.getEdgeCenters(
                            elementPosition: endElement.position,
                            elementSize: endElement.size
                        ).leading
                    )
                )
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
