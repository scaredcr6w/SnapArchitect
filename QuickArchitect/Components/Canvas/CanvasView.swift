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
    @Binding var selectedTool: OOPElementType?
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
                            if let newElement = viewModel.newElement(geo, selectedTool) {
                                document.entityRepresentations.append(newElement)
                                selectedElement = nil
                                selectedTool = nil
                            }
                        }
                )
            }
            .scrollIndicators(.hidden)
        }
        
    }
}
