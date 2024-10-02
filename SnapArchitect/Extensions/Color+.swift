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
        guard let components = NSColor(self).cgColor.components else {
            return "1.0,1.0,1.0,1.0"
        }
        return components.map { String(Double($0)) }.joined(separator: ",")
    }
    
    public init?(rawValue: String) {
        let components = rawValue.split(separator: ",").compactMap { Double($0) }
        guard components.count == 4 else { return nil }
        
        self = Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
}
