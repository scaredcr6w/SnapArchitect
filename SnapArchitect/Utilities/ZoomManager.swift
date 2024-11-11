//
//  ZoomManager.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 05..
//

import Foundation

class ZoomManager: ObservableObject {
    @Published var currentScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var currentOffset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    @Published var mouseLocation: CGPoint = .zero
    
    let minScale: CGFloat = 1.0
    let maxScale: CGFloat = 3.0
}
