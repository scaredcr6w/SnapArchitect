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

struct SnapArchitectDiagram: Codable {
    var isSelected: Bool
    var entityRepresentations: [OOPElementRepresentation]
    var entityConnections: [OOPConnectionRepresentation]
}

struct SnapArchitectDocument: FileDocument, Codable {
    var diagrams: [SnapArchitectDiagram]
    init(diagrams: [SnapArchitectDiagram] = [SnapArchitectDiagram(isSelected: true, entityRepresentations: [], entityConnections: [])]) {
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
