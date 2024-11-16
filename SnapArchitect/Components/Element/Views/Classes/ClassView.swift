//
//  ClassView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ClassView: View {
    @ObservedObject var viewModel: ClassViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text(viewModel.typeString)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Text(viewModel.element.name)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Divider()
                    .foregroundStyle(.black)
            }
            VStack {
                VStack(alignment: .leading) {
                    ForEach(viewModel.element.attributes) { attribute in
                        Text(
                            "\(viewModel.getAccessMofifier(attribute.access)) \(attribute.name): \(attribute.type)"
                        )
                        .font(.caption2)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 12)
                    }
                    Divider()
                        .foregroundStyle(.black)
                }
                VStack(alignment: .leading) {
                    ForEach(viewModel.element.functions, id: \.id) { function in
                        DisclosureGroup(
                            "\(viewModel.getAccessMofifier(function.access)) \(function.name): \(function.returnType)"
                        ) {
                            Text(function.functionBody)
                                .font(.caption2)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.caption2)
                    }
                }
            }
        }
        .frame(width: viewModel.element.size.width)
        .frame(minWidth: 100)
        .frame(minHeight: viewModel.element.size.height, alignment: .top)
        .background(.white)
        .border(width: 1, edges: [.bottom, .top, .leading, .trailing], color: .black)
        .overlay(
            Group {
                if viewModel.element.isSelected {
                    //top leading
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.topLeadingHandle(value)
                                }
                        )
                        .position(x: 0, y: 0)
                    //top trailing
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.topTrailingHandle(value)
                                }
                        )
                        .position(x: viewModel.element.size.width, y: 0)
                    //bottom leading
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.bottomLeadingHandle(value)
                                }
                        )
                        .position(x: 0, y: viewModel.element.size.height)
                    //bottom trailing
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.bottomTrailingHandle(value)
                                }
                        )
                        .position(x: viewModel.element.size.width, y: viewModel.element.size.height)
                }
            }
        )
        .shadow(radius: 10, x: 10, y: 10)
        .position(viewModel.element.position)
    }
    
    var handleView: some View {
        Circle()
            .stroke(.accent, lineWidth: 1.5)
            .frame(width: 10, height: 10)
            .contentShape(Circle())
    }
}

//#Preview {
//    ClassView(
//        representation: .constant(OOPElementRepresentation(
//            .accessInternal,
//            "Class",
//            .classType,
//            CGPoint(x: 100, y: 100),
//            CGSize(width: 100, height: 100))),
//        backgroundColor: .white,
//        isSelected: true
//    )
//}
