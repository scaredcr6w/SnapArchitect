//
//  DocumentProtocol.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation

protocol DocumentProtocol: AnyObject {
    func registerUndo<Target: AnyObject>(with target: Target, handler: @escaping (Target) -> Void)
    func updateDocument()
}
