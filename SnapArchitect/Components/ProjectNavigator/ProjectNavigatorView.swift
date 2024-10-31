//
//  ProjectNavigatorView.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 01..
//

import SwiftUI

struct ProjectNavigatorView: View {
    @EnvironmentObject private var toolManager: ToolManager
    @Binding var document: SnapArchitectDocument
    @State private var selectedDiagram = Set<UUID>()
    
    var body: some View {
        VStack {
            Section {
                List(document.diagrams, selection: $selectedDiagram) { diagram in
                    Text(diagram.diagramName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onAppear {
                            if diagram.isSelected {
                                selectedDiagram.insert(diagram.id)
                            }
                        }
                        .onTapGesture {
                            selectedDiagram.removeAll()
                            toolManager.selectedElements.removeAll()
                            toolManager.selectedConnections.removeAll()
                            selectedDiagram.insert(diagram.id)
                            
                            for index in document.diagrams.indices {
                                document.diagrams[index].isSelected = (document.diagrams[index].id == diagram.id)
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            } header: {
                HStack {
                    Text("Diagram Explorer")
                        .font(.title3)
                    Image(systemName: "plus")
                        .background(.clear)
                        .onTapGesture {
                            document.diagrams.append(
                                .init(
                                    isSelected: false,
                                    entityRepresentations: [],
                                    entityConnections: []
                                )
                            )
                        }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}
