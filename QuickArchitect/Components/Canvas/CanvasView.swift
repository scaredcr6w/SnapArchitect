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
    
    private func updateScrollOffsets(geo: GeometryProxy) {
        viewModel.xScrollOffset = geo.frame(in: .global).minX
        viewModel.yScrollOffset = geo.frame(in: .global).minY
    }
    
    private func placeEntity(_ geo: GeometryProxy) {
        if let event = NSApp.currentEvent, let type = selectedTool {
            let clickLocation = viewModel.getMouseClick(geo, event: event)
            document.entityRepresentations.append(
                OOPElementRepresentation(type.rawValue, type, clickLocation, CGSize(width: 100, height: 100))
            )
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
                ScrollViewReader { scrollViewProxy in
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
                                updateScrollOffsets(geo: innerGeo)
                            }
                            .onChange(of: innerGeo.frame(in: .global)) {
                                updateScrollOffsets(geo: innerGeo)
                            }
                    })
                    .gesture(
                        TapGesture()
                            .onEnded{ _ in
                                placeEntity(geo)
                                selectedElement = nil
                                selectedTool = nil
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
        
    }
}
