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
        ZStack {
            CanvasView(viewModel: canvasViewModel, document: $document, selectedTool: $selectedTool)
            ToolbarView(viewModel: toolBarViewModel, selectedTool: $selectedTool)
        }
        .onChange(of: selectedTool) { _, _ in
            print("Selection changed to: \(selectedTool)")
        }
    }
}

#Preview {
    EditorView(document: .constant(QuickArchitectDocument()), canvasViewModel: CanvasViewModel(), toolBarViewModel: ToolbarViewModel())
}
