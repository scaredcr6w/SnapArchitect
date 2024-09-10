//
//  EditorView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: QuickArchitectDocument
    @Binding var selectedTool: OOPElementType?
    @Binding var selectedElement: OOPElementRepresentation?
    
    var body: some View {
        GeometryReader { windowGeo in
            let windowWidth = windowGeo.size.width
            let windowHeight = windowGeo.size.height
            
            NavigationSplitView {
                if let element = selectedElement {
                    let bindingElement = Binding<OOPElementRepresentation>(
                        get: { element },
                        set: { selectedElement = $0 }
                    )
                    EditElementView(element: bindingElement)
                        .frame(minWidth: 270)
                } else {
                    Text("No element selected")
                        .frame(minWidth: 270)
                }
            } detail: {
                ZStack {
                    CanvasView(document: $document, selectedTool: $selectedTool, selectedElement: $selectedElement)
                        .frame(width: windowWidth, height: windowHeight)
                    ToolbarView(selectedTool: $selectedTool, selectedElement: $selectedElement)
                        .frame(height: windowHeight)
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
