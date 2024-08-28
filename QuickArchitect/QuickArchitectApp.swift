//
//  QuickArchitectApp.swift
//  QuickArchitect
//
//  Created by Anda Levente on 27/08/2024.
//

import SwiftUI

@main
struct QuickArchitectApp: App {
    var body: some Scene {
//        DocumentGroup(newDocument: QuickArchitectDocument()) { file in
//            ContentView(document: file.$document)
//        }
        WindowGroup {
            ContentView()
        }
    }
}
