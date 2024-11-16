//
//  ClassViewModel.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation
import SwiftUI
import Combine

class ClassViewModel: ObservableObject {
    @AppStorage("snapToGrid") private var snapToGrid: Bool = false
    @AppStorage("gridSize") private var gridSize: Double = 10
    @Published var document: SnapArchitectDocument
    @Published var element: OOPElementRepresentation
    let minWidth: CGFloat = 100
    let minHeight: CGFloat = 50
    
    private let documentProxy: DocumentProxy
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        _ representation: OOPElementRepresentation,
        _ document: SnapArchitectDocument,
        _ documentProxy: DocumentProxy
    ) {
        self.element = representation
        self.document = document
        self.documentProxy = documentProxy
        setupBindings()
    }
    
    func setupBindings() {
        $element
            .sink { [weak self] updatedElement in
                DispatchQueue.main.async {
                    self?.saveChanges(updatedElement)
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveChanges(_ element: OOPElementRepresentation) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            document.diagrams[diagramIndex].entityRepresentations = document.diagrams[diagramIndex].entityRepresentations.map {
                $0.id == element.id ? element : $0
            }
        }
    }
    
    var typeString: String {
        switch element.type {
        case .classType:
            return "<< class >>"
        case .structType:
            return "<< struct >>"
        case .protocolType:
            return "<< protocol >>"
        case .enumType:
            return "<< enum >>"
        }
    }
    
    func getAccessMofifier(_ access: OOPAccessModifier) -> String {
        switch access {
        case .accessInternal:
            return ""
        case .accessPublic:
            return "+"
        case .accessProtected:
            return "#"
        case .accessPrivate:
            return "-"
        }
    }
    
    func snapToGrid(_ value: Double, gridSize: Double) -> Double {
        return round(value / gridSize) * gridSize
    }
    
    func topLeadingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, element.size.width - value.translation.width)
        var newHeight = max(50, element.size.height - value.translation.height)
        var newX = element.position.x + value.translation.width / 2
        var newY = element.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - element.size.width / 2, gridSize: gridSize) + element.size.width / 2
            newY = snapToGrid(newY - element.size.height / 2, gridSize: gridSize) + element.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            element.size.width = newWidth
            element.position.x = newX
        }
        if newHeight > minHeight {
            element.size.height = newHeight
            element.position.y = newY
        }
    }
    
    func topTrailingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, element.size.width + value.translation.width)
        var newHeight = max(50, element.size.height - value.translation.height)
        var newX = element.position.x + value.translation.width / 2
        var newY = element.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - element.size.width / 2, gridSize: gridSize) + element.size.width / 2
            newY = snapToGrid(newY - element.size.height / 2, gridSize: gridSize) + element.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            element.size.width = newWidth
            element.position.x = newX
        }
        if newHeight > minHeight {
            element.size.height = newHeight
            element.position.y = newY
        }
    }
    
    func bottomLeadingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, element.size.width - value.translation.width)
        var newHeight = max(50, element.size.height + value.translation.height)
        var newX = element.position.x + value.translation.width / 2
        var newY = element.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - element.size.width / 2, gridSize: gridSize) + element.size.width / 2
            newY = snapToGrid(newY - element.size.height / 2, gridSize: gridSize) + element.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            element.size.width = newWidth
            element.position.x = newX
        }
        if newHeight > minHeight {
            element.size.height = newHeight
            element.position.y = newY
        }
    }
    
    func bottomTrailingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, element.size.width + value.translation.width)
        var newHeight = max(50, element.size.height + value.translation.height)
        var newX = element.position.x + value.translation.width / 2
        var newY = element.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - element.size.width / 2, gridSize: gridSize) + element.size.width / 2
            newY = snapToGrid(newY - element.size.height / 2, gridSize: gridSize) + element.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            element.size.width = newWidth
            element.position.x = newX
        }
        if newHeight > minHeight {
            element.size.height = newHeight
            element.position.y = newY
        }
    }
}
