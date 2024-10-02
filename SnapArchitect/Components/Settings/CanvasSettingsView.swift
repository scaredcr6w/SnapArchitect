//
//  CanvasSettingsView.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 02..
//

import SwiftUI

struct CanvasSettingsView: View {
    @AppStorage("canvasBackgorundColor") private var backgroundColor: Color = .white
    @AppStorage("snapToGrid") private var snapToGrid: Bool = false
    @AppStorage("gridSize") private var gridSize: Double = 10
    
    var body: some View {
        Form {
            Toggle("Snap to grid", isOn: $snapToGrid)
            Slider(value: $gridSize, in: 1...20) {
                Text("Grid Size: \(gridSize, specifier: "%.1f") pts")
            }
            ColorPicker("Background Color", selection: $backgroundColor)
        }
    }
}

#Preview {
    CanvasSettingsView()
}
