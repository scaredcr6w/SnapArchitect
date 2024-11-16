//
//  ProjectNavigatorView.swift
//  SnapArchitect
//
//  Created by Anda Levente on 2024. 10. 01..
//

import SwiftUI

struct ProjectNavigatorView: View {
    @StateObject var viewModel: ProjectNavigatorViewModel
    
    var body: some View {
        VStack {
            Section {
                List(viewModel.document.diagrams, selection: $viewModel.selectedDiagram) { diagram in
                    Text(diagram.diagramName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onAppear {
                            viewModel.loadDiagram(diagram)
                        }
                        .onTapGesture {
                            viewModel.switchDiagram(diagram)
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
                            viewModel.newDiagram()
                        }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}
