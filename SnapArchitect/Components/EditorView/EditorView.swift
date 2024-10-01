//
//  EditorView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: SnapArchitectDocument
    @Binding var selectedTool: Any?
    @Binding var selectedElement: OOPElementRepresentation?
    
    @ViewBuilder
    private func toolbar() -> some View {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }),
           let element = selectedElement,
           let elementIndex = document.diagrams[diagramIndex].entityRepresentations.firstIndex(where: { $0.id == element.id }) {
            let bindingElement = $document.diagrams[diagramIndex].entityRepresentations[elementIndex]
            EditElementView(element: bindingElement)
        } else {
            Text("No element selected")
        }
    }
    
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
                toolbar()
                    .frame(width: 270, height: windowHeight)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        
    }
}