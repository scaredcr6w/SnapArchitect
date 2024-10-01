//
//  QuickArchitectDocument.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let quickArchitectDocument = UTType(exportedAs: "com.snaparchitect.qad")
}

struct SnapArchitectDiagram: Codable, Identifiable, Hashable {
    var id = UUID()
    var diagramName: String
    var isSelected: Bool
    var entityRepresentations: [OOPElementRepresentation]
    var entityConnections: [OOPConnectionRepresentation]
    
    private static var diagramIndex: Int = 0
    
    init(
        isSelected: Bool,
        entityRepresentations: [OOPElementRepresentation],
        entityConnections: [OOPConnectionRepresentation]
    ) {
        SnapArchitectDiagram.diagramIndex += 1
        self.diagramName = "Diagram\(SnapArchitectDiagram.diagramIndex)"
        self.isSelected = isSelected
        self.entityRepresentations = entityRepresentations
        self.entityConnections = entityConnections
    }
}

struct SnapArchitectDocument: FileDocument, Codable {
    var diagrams: [SnapArchitectDiagram]
    init(diagrams: [SnapArchitectDiagram] = [.init(isSelected: true, entityRepresentations: [], entityConnections: [])]) {
        self.diagrams = diagrams
    }

    static var readableContentTypes: [UTType] { [.quickArchitectDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self = try decoder.decode(SnapArchitectDocument.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return .init(regularFileWithContents: data)
    }
}
