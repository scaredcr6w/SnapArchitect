//
//  Color+.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 02..
//

import SwiftUI
import AppKit

extension Color: @retroactive RawRepresentable {
    public var rawValue: String {
        guard let nsColor = NSColor(self).usingColorSpace(.deviceRGB),
              let components = nsColor.cgColor.components else {
            return "1.0,1.0,1.0,1.0"
        }
        let red = components.count > 0 ? components[0] : 1.0
        let green = components.count > 1 ? components[1] : 1.0
        let blue = components.count > 2 ? components[2] : 1.0
        let opacity = components.count > 3 ? components[3] : 1.0
        
        return String(format: "%.6f,%.6f,%.6f,%.6f", red, green, blue, opacity)
    }
    
    public init?(rawValue: String) {
        let components = rawValue.split(separator: ",").compactMap { Double($0) }
        guard components.count == 4 else { return nil }
        
        self = Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
}
