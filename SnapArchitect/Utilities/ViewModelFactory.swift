//
//  ViewModelFactory.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation

class ViewModelFactory {
    static func makeCanvasViewModel(
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProtocol
    ) -> CanvasViewModel {
        return CanvasViewModel(document, documentProxy)
    }
    
    static func makeClassViewModel(
        for element: OOPElementRepresentation,
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProtocol
    ) -> ClassViewModel {
        return ClassViewModel(
            element,
            document,
            documentProxy
        )
    }
    
    static func makeEditElementViewModel(
        for element: OOPElementRepresentation,
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProtocol
    ) -> EditElementViewModel {
        return EditElementViewModel(
            element: element,
            document: document,
            documentProxy: documentProxy
        )
    }
    
    static func makeToolbarViewModel() -> ToolbarViewModel {
        return ToolbarViewModel()
    }
    
    static func makeProjectNavigatorViewModel(
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProtocol
    ) -> ProjectNavigatorViewModel {
        return ProjectNavigatorViewModel(
            document,
            documentProxy
        )
    }
}
