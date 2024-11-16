//
//  FocusModifier.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import SwiftUI

struct FocusModifier: ViewModifier {
    @FocusState.Binding var isFocused: Bool
    var onFocusChange: (Bool) -> Void
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { _, focused in
                onFocusChange(focused)
            }
    }
}
