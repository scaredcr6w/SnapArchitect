//
//  EditorView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: QuickArchitectDocument
    @Binding var selectedTool: Any?
    @Binding var selectedElement: OOPElementRepresentation?
    
    var body: some View {
        GeometryReader { windowGeo in
            let windowHeight = windowGeo.size.height
            HStack(spacing: 0) {
                NavigationSplitView {
                    ToolbarView(selectedTool: $selectedTool, selectedElement: $selectedElement)
                        .navigationSplitViewColumnWidth(270)
                        
                } detail: {
                    CanvasView(document: $document, selectedTool: $selectedTool, selectedElement: $selectedElement)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if let element = selectedElement {
                    let bindingElement = Binding<OOPElementRepresentation>(
                        get: { element },
                        set: { selectedElement = $0 }
                    )
                    EditElementView(element: bindingElement)
                        .frame(width: 270, height: windowHeight)
                } else {
                    Text("No element selected")
                        .frame(width: 270, height: windowHeight)
                }
                
            }
        }
        .frame(minWidth: 800, minHeight: 600)
       
    }
}
