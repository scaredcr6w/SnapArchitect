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
        }
    }
    
    var body: some View {
        GeometryReader { canvasGeo in
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    ForEach(document.entityRepresentations) { object in
                        representationView(object)
                            .position(object.position)
                    }
                }
                
                .frame(
                    width: 3000,
                    height: 3000
                )
                .background(.white)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            if let event = NSApp.currentEvent, let type = selectedTool {
                                let clickLocation = viewModel.getMouseClick(canvasGeo, event: event)
                                document.entityRepresentations.append(
                                    OOPElementRepresentation(type: type, position: clickLocation)
                                )
                            }
                        }
                )
            }
            .scrollIndicators(.hidden)
        }
    }
}
