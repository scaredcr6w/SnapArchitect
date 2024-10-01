//
//  View+.swift
//  QuickArchitect
//
//  Created by Anda Levente on 02/09/2024.
//

import Foundation
import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges )).foregroundStyle(color)
    }
    
    func corner(size: CGSize, anchor: UnitPoint, color: Color) -> some View {
        overlay(CornerRect(size: size, anchor: anchor)).foregroundStyle(color)
    }
}

struct CornerRect: Shape {
    var size: CGSize
    var anchor: UnitPoint
    
    func path(in rect: CGRect) -> Path {
        switch anchor {
        case .topLeading:
            return Path(.init(x: rect.minX - size.width * 0.25, y: rect.minY - size.height * 0.25, width: size.width, height: size.height))
        case .topTrailing:
            return Path(.init(x: rect.maxX - size.width * 0.75, y: rect.minY - size.height * 0.25, width: size.width, height: size.height))
        case .bottomLeading:
            return Path(.init(x: rect.minX - size.width * 0.25, y: rect.maxY - size.height * 0.75, width: size.width, height: size.height))
        case .bottomTrailing:
            return Path(.init(x: rect.maxX - size.width * 0.75, y: rect.maxY - size.height * 0.75, width: size.width, height: size.height))
        default:
            return Path(CGRect.zero)
        }
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }
        .reduce(into: Path()) { $0.addPath($1) }
    }
}
