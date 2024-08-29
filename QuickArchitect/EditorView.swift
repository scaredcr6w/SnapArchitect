//
//  EditorView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: QuickArchitectDocument
    @StateObject var canvasViewModel = CanvasViewModel()
    @StateObject var toolBarViewModel = ToolbarViewModel()
    @State var selectedTool: OOPElementType? = nil
    
    var body: some View {
        GeometryReader { windowGeo in
            let windowWidth = windowGeo.size.width
            let windowHeight = windowGeo.size.height
            
            ZStack {
                CanvasView(viewModel: canvasViewModel, document: $document, selectedTool: $selectedTool)
                    .frame(width: windowWidth, height: windowHeight)
                ToolbarView(viewModel: toolBarViewModel, selectedTool: $selectedTool)
                    .frame(height: windowHeight)
            }
        }
    }
}

#Preview {
    EditorView(document: .constant(QuickArchitectDocument()), canvasViewModel: CanvasViewModel(), toolBarViewModel: ToolbarViewModel())
}
