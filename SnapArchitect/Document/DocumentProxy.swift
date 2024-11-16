//
//  DocumentProxy.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation
import AppKit

struct DocumentProxy {
    let documentController: NSDocumentController = .shared
    let undoManager: UndoManager?
    
    func registerUndo<Target>(
        with target: Target,
        handler: @escaping (Target) -> Void
    ) where Target : AnyObject {
        if let undoManager = undoManager {
            undoManager.registerUndo(withTarget: target, handler: handler)
        }
    }
    
    func updateDocument() {
        if let document = documentController.currentDocument {
            document.updateChangeCount(.changeDone)
        }
    }
}
