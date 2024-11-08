//
//  EditorView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: SnapArchitectDocument
    @EnvironmentObject private var toolManager: ToolManager
    
    @ViewBuilder
    private func rightSidebar(windowHeight: CGFloat) -> some View {
        VStack {
            if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
                let selectedElementsCount = document.diagrams[diagramIndex].entityRepresentations.lazy.filter({ $0.isSelected }).count
                if selectedElementsCount > 1 {
                    Text("Multiple elements selected")
                        .font(.title2)
                        .frame(height: windowHeight / 2)
                } else if selectedElementsCount == 0 {
                    Text("No element selected")
                        .font(.title2)
                        .frame(height: windowHeight / 2)
                } else {
                    if let element = document.diagrams[diagramIndex].entityRepresentations.last(where: { $0.isSelected }),
                       let elementIndex = document.diagrams[diagramIndex].entityRepresentations.firstIndex(where: { $0.id == element.id }) {
                        let bindingElement = $document.diagrams[diagramIndex].entityRepresentations[elementIndex]
                        EditElementView(element: bindingElement)
                            .frame(height: windowHeight / 2)
                    }
                }
            }
            Divider()
            ProjectNavigatorView(document: $document)
                .frame(height: windowHeight / 2)
        }
    }
    
    var body: some View {
        GeometryReader { windowGeo in
            let windowHeight = windowGeo.size.height
            HStack(spacing: 0) {
                NavigationSplitView {
                    ToolbarView()
                        .navigationSplitViewColumnWidth(270)
                    
                } detail: {
                    CanvasView(document: $document)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                rightSidebar(windowHeight: windowHeight)
                    .frame(width: 270, height: windowHeight)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .environmentObject(toolManager)
    }
}
