//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    let viewModel: CanvasViewModel
    @Binding var document: QuickArchitectDocument
    @Binding var selectedTool: OOPElementType?
    
    @ViewBuilder
    private func representationView(_ representation: OOPElementRepresentation) -> some View {
        switch representation.type {
        case .classType:
            ClassView(className: "ClassView")
        case .structType:
            StructView(structName: "StructView")
        case .protocolType:
            ProtocolView(protocolName: "ProtocolView")
        case .enumType:
            EnumView(enumName: "EnumView")
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
                            ForEach(document.entityRepresentations) { object in
                                representationView(object)
                                    .position(object.position)
                            }
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
                                if let event = NSApp.currentEvent, let type = selectedTool {
                                    let clickLocation = viewModel.getMouseClick(geo, event: event)
                                    document.entityRepresentations.append(
                                        OOPElementRepresentation(type: type, position: clickLocation)
                                    )
                                }
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
        
    }
    
    private func updateScrollOffsets(geo: GeometryProxy) {
        viewModel.xScrollOffset = geo.frame(in: .global).minX
        viewModel.yScrollOffset = geo.frame(in: .global).minY
        
        print("x: \(viewModel.xScrollOffset), y: \(viewModel.yScrollOffset)")
    }
}
