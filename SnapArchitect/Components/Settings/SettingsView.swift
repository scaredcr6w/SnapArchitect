//
//  SettingsView.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 02..
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            CanvasSettingsView()
                .tabItem {
                    Label("Canvas", systemImage: "square.and.pencil")
                }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

#Preview {
    SettingsView()
}
