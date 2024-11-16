//
//  ViewModelFactory.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation

class ViewModelFactory {
    static func makeClassViewModel(for element: OOPElementRepresentation, _ document: SnapArchitectDocument) -> ClassViewModel {
        return ClassViewModel(element, document)
    }
    
    static func makeEditElementViewModel(for element: OOPElementRepresentation, _ document: SnapArchitectDocument) -> EditElementViewModel {
        return EditElementViewModel(element: element, document: document)
    }
    
    static func makeToolbarViewModel() -> ToolbarViewModel {
        return ToolbarViewModel()
    }
    
    static func makeProjectNavigatorViewModel(_ document: SnapArchitectDocument) -> ProjectNavigatorViewModel {
        return ProjectNavigatorViewModel(document)
    }
}
