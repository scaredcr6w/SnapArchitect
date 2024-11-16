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

class SnapArchitectDocument: ReferenceFileDocument {
    typealias Snapshot = [SnapArchitectDiagram]
    static var readableContentTypes: [UTType] { [.quickArchitectDocument] }
    
    @Published var diagrams: Snapshot {
        didSet {
            NotificationCenter.default.post(name: .documentDidChange, object: nil)
        }
    }
    
    init(diagrams: Snapshot = [.init(isSelected: true, entityRepresentations: [], entityConnections: [])]) {
        self.diagrams = diagrams
    }
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        diagrams = try JSONDecoder().decode(Snapshot.self, from: data)
        
    }
    
    func snapshot(contentType: UTType) throws -> Snapshot {
        return diagrams
    }
    
    func fileWrapper(snapshot: Snapshot, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        return FileWrapper(regularFileWithContents: data)
    }
}

