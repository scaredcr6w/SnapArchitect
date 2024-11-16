//
//  EditElementViewModel.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 11. 16..
//

import Foundation
import Combine

class EditElementViewModel: ObservableObject {
    @Published var document: SnapArchitectDocument
    @Published var element: OOPElementRepresentation
    @Published var showAddAttribute: Bool = false
    @Published var showAddFunction: Bool = false
    @Published var newAttributeName: String = ""
    @Published var newAttributeType: String = ""
    @Published var newFunctionName: String = ""
    @Published var newFunctionReturnType: String = ""
    @Published var newFunctionBody: String = ""
    @Published var selectedAccessModifier: OOPAccessModifier = .accessPublic
    
    @Published var didError: Bool = false
    @Published var errorMessage: String?
    
    private let documentProxy: DocumentProxy
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        element: OOPElementRepresentation,
        document: SnapArchitectDocument,
        documentProxy: DocumentProxy
    ) {
        self.element = element
        self.document = document
        self.documentProxy = documentProxy
        setupBindings()
    }
    
    private func setupBindings() {
        $element
            .sink { [weak self] updatedElement in
                DispatchQueue.main.async {
                    self?.validateElement(updatedElement) { errorMessage in
                        self?.didError = true
                        self?.errorMessage = errorMessage
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func validateElement(
        _ element: OOPElementRepresentation,
        _ onInvalid: (String) -> Void
    ) {
        guard element.name.contains(where: { $0.isWhitespace }) == false else {
            let errorMessage = "Element name cannot be empty."
            onInvalid(errorMessage)
            return
        }
        
        saveChanges(element)
    }
    
    private func saveChanges(_ element: OOPElementRepresentation) {
        if let diagramIndex = document.diagrams.firstIndex(where: { $0.isSelected }) {
            document.diagrams[diagramIndex].entityRepresentations = document.diagrams[diagramIndex].entityRepresentations.map {
                $0.id == element.id ? element : $0
            }
        }
    }
    
    func addAttribute(_ attribute: OOPElementAttribute) {
        element.attributes.append(attribute)
        
        documentProxy.registerUndo(with: self) { target in
            target.removeAttribute(attribute)
        }
        
        documentProxy.updateDocument()
        
        selectedAccessModifier = .accessPublic
        newAttributeName = ""
        newAttributeType = ""
    }
    
    func addFunction(_ function: OOPElementFunction) {
        element.functions.append(function)
        
        documentProxy.registerUndo(with: self) { target in
            target.removeFunction(function)
        }
        
        documentProxy.updateDocument()
        
        selectedAccessModifier = .accessPublic
        newFunctionName = ""
        newFunctionReturnType = ""
        newFunctionBody = ""
    }
    
    func removeAttribute(_ attribute: OOPElementAttribute) {
        element.attributes.removeAll { $0 == attribute }
    }
    
    func removeFunction(_ function: OOPElementFunction) {
        element.functions.removeAll { $0 == function }
    }
    
    func focusTextField(_ focused: Bool) {
        ToolManager.shared.isEditing = focused
    }
}
