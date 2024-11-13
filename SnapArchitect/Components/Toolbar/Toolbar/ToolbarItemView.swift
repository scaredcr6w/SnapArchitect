//
//  ToolbarItemView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarItemView: View {
    let elementName: String
    let elementType: Any?
    
    @State private var isSelected: Bool = false
    
    init(_ elementName: String, _ elementType: Any?) {
        self.elementName = elementName
        self.elementType = elementType
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 6)
                .fill(.accent)
                .opacity(isSelected ? 1 : 0)
            Text(elementName)
                .padding(.horizontal)
        }
        .frame(height: 20)
        .onAppear {
            updateSelection()
            NotificationCenter.default.addObserver(forName: .toolSelected, object: nil, queue: .main) { _ in
                updateSelection()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .toolSelected, object: nil)
        }
    }
    
    private func updateSelection() {
        if let elementType = elementType as? OOPElementType,
           let selectedTool = ToolManager.shared.selectedTool as? OOPElementType {
            isSelected = (selectedTool == elementType)
        } else if let elementType = elementType as? OOPConnectionType,
                  let selectedTool = ToolManager.shared.selectedTool as? OOPConnectionType {
            isSelected = (selectedTool == elementType)
        } else {
            isSelected = false
        }
    }
}
