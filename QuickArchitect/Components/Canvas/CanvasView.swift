//
//  CanvasView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct CanvasView: View {
    @StateObject private var viewModel = CanvasViewModel()
    @State private var objects: [ClassRepresentation] = []
    
    
    var body: some View {
        GeometryReader { windowGeo in
            let canvasWidth = windowGeo.size.width
            let canvasHeight = windowGeo.size.height
            
            GeometryReader { canvasGeo in
                ZStack {
                    ForEach(objects) { object in
                        ClassView(className: "ToolbarItemsViewModel")
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
                                objects.append(
                                    ClassRepresentation(position: clickLocation)
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
    CanvasView()
}
