//
//  ToolbarItemView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 29/08/2024.
//

import SwiftUI

struct ToolbarItemView: View {
    let elementName: String
    var isSelected: Bool
    
    init(_ elementName: String, _ isSelected: Bool) {
        self.elementName = elementName
        self.isSelected = isSelected
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
    }
}

#Preview {
    ToolbarItemView("Enumeration", true)
}
