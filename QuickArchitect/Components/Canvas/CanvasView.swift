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
        GeometryReader { windowGeo in
            let canvasWidth = windowGeo.size.width
            let canvasHeight = windowGeo.size.height
            
            GeometryReader { canvasGeo in
                ZStack {
                    ForEach(document.entityRepresentations) { object in
                        representationView(object)
                            .position(object.position)
                    }
                }
                .frame(
                    width: canvasWidth,
                    height: canvasHeight
                )
                .background(.white)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            if let event = NSApp.currentEvent {
                                let clickLocation = viewModel.getMouseClick(canvasGeo, event: event)
                                document.entityRepresentations.append(
                                    OOPElementRepresentation(type: .classType, position: clickLocation)
                                )
                            }
                        }
                )
            }
            .frame(
                width: canvasWidth,
                height: canvasHeight
            )
        }
    }
}

#Preview {
    CanvasView(document: .constant(QuickArchitectDocument()))
}
