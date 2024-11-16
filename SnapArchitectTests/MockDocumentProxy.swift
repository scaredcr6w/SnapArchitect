//
//  MockDocumentProxy.swift
//  SnapArchitectTests
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation
@testable import Snap_Architect

class MockDocumentProxy: DocumentProtocol {
    var registerUndoCalled = false
    var updateDocumentCalled = false
    
    func registerUndo<Target>(with target: Target, handler: @escaping (Target) -> Void) where Target : AnyObject {
        registerUndoCalled = true
    }
    
    func updateDocument() {
        updateDocumentCalled = true
    }
}
