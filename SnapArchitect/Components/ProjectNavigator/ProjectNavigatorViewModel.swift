//
//  ProjectNavigatorViewModel.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation

class ProjectNavigatorViewModel: ObservableObject {
    @Published var document: SnapArchitectDocument
    @Published var selectedDiagram = Set<UUID>()
    
    init(_ document: SnapArchitectDocument) {
        self.document = document
    }
    
    func loadDiagram(_ diagram: SnapArchitectDiagram) {
        if diagram.isSelected {
            selectedDiagram.insert(diagram.id)
        }
    }
    
    func switchDiagram(_ diagram: SnapArchitectDiagram) {
        selectedDiagram.removeAll()
        selectedDiagram.insert(diagram.id)
        
        for index in document.diagrams.indices {
            document.diagrams[index].isSelected = (document.diagrams[index].id == diagram.id)
        }
    }
    
    func newDiagram() {
        document.diagrams.append(
            .init(
                isSelected: false,
                entityRepresentations: [],
                entityConnections: []
            )
        )
    }
}
