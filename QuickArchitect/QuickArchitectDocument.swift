//
//  QuickArchitectDocument.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let quickArchitectDocument = UTType(exportedAs: "com.quickarchitect.qad")
}

struct QuickArchitectDocument: FileDocument, Codable {
    var text: String

    init(text: String = "") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.quickArchitectDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self = try decoder.decode(QuickArchitectDocument.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return .init(regularFileWithContents: data)
    }
}
