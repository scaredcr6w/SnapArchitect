//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    @StateObject var viewModel: CanvasViewModel
    @Binding var document: QuickArchitectDocument
    @Binding var selectedTool: OOPElementType?
    @State private var selectedEntity: UUID?
    
    private func updateScrollOffsets(geo: GeometryProxy) {
        viewModel.xScrollOffset = geo.frame(in: .global).minX
        viewModel.yScrollOffset = geo.frame(in: .global).minY
    }
    
    private func placeEntity(_ geo: GeometryProxy) {
        if let event = NSApp.currentEvent, let type = selectedTool {
            let clickLocation = viewModel.getMouseClick(geo, event: event)
            document.entityRepresentations.append(
                OOPElementRepresentation("IDK", type, position: clickLocation, size: CGSize(width: 100, height: 150))
            )
        }
    }
    
    @ViewBuilder
    private func representationView(_ representation: Binding<OOPElementRepresentation>) -> some View {
        switch representation.wrappedValue.type {
        case .classType:
            ClassView(representation: representation)
        case .structType:
            StructView(representation: representation)
        case .protocolType:
            ProtocolView(representation: representation)
        case .enumType:
            EnumView(representation: representation)
        case .association:
            EmptyView()
        case .directedAssociation:
            EmptyView()
        case .aggregation:
            EmptyView()
        case .composition:
            EmptyView()
        case .dependency:
            EmptyView()
        case .generalization:
            EmptyView()
        case .protocolRealization:
            EmptyView()
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ZStack {
                            ForEach($document.entityRepresentations) { $object in
                                representationView($object)
                                    .position(object.position)
                                    .onTapGesture {
                                        selectedEntity = object.id
                                    }
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                if selectedEntity == object.id {
                                                    object.position = value.location
                                                }
                                            }
                                    )
                            }
                        }
                        .frame(width: geo.size.width * 3, height: geo.size.height * 3)
                    }
                    .background(.white)
                    .onTapGesture {
                        selectedEntity = nil
                    }
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
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
        
    }
}
