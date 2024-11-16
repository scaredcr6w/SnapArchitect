//
//  DocumentReader.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import SwiftUI

struct DocumentReader<Content>: View where Content: View {
    @Environment(\.undoManager) var _undoManager
    
    let content: (DocumentProtocol) -> Content
    
    init(@ViewBuilder content: @escaping (DocumentProtocol) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(DocumentProxy(undoManager: _undoManager))
    }
}

