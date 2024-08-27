//
//  ContentView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: QuickArchitectDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(QuickArchitectDocument()))
}