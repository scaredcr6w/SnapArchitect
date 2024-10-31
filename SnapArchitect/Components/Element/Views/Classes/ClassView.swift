//
//  ClassView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ClassView: View {
    @AppStorage("snapToGrid") private var snapToGrid: Bool = false
    @AppStorage("gridSize") private var gridSize: Double = 10
    @Binding var representation: OOPElementRepresentation
    @State var backgroundColor: Color = .white
    @Binding var isSelected: Bool
    let minWidth: CGFloat = 100
    let minHeight: CGFloat = 50
    
    private var typeString: String {
        switch representation.type {
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
    
    private func getAccessMofifier(_ access: OOPAccessModifier) -> String {
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
    
    private func snapToGrid(_ value: Double, gridSize: Double) -> Double {
        return round(value / gridSize) * gridSize
    }
    
    private func topLeadingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, representation.size.width - value.translation.width)
        var newHeight = max(50, representation.size.height - value.translation.height)
        var newX = representation.position.x + value.translation.width / 2
        var newY = representation.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - representation.size.width / 2, gridSize: gridSize) + representation.size.width / 2
            newY = snapToGrid(newY - representation.size.height / 2, gridSize: gridSize) + representation.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            representation.size.width = newWidth
            representation.position.x = newX
        }
        if newHeight > minHeight {
            representation.size.height = newHeight
            representation.position.y = newY
        }
    }
    
    private func topTrailingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, representation.size.width + value.translation.width)
        var newHeight = max(50, representation.size.height - value.translation.height)
        var newX = representation.position.x + value.translation.width / 2
        var newY = representation.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - representation.size.width / 2, gridSize: gridSize) + representation.size.width / 2
            newY = snapToGrid(newY - representation.size.height / 2, gridSize: gridSize) + representation.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            representation.size.width = newWidth
            representation.position.x = newX
        }
        if newHeight > minHeight {
            representation.size.height = newHeight
            representation.position.y = newY
        }
    }
    
    private func bottomLeadingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, representation.size.width - value.translation.width)
        var newHeight = max(50, representation.size.height + value.translation.height)
        var newX = representation.position.x + value.translation.width / 2
        var newY = representation.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - representation.size.width / 2, gridSize: gridSize) + representation.size.width / 2
            newY = snapToGrid(newY - representation.size.height / 2, gridSize: gridSize) + representation.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            representation.size.width = newWidth
            representation.position.x = newX
        }
        if newHeight > minHeight {
            representation.size.height = newHeight
            representation.position.y = newY
        }
    }
    
    private func bottomTrailingHandle(_ value: DragGesture.Value) {
        var newWidth = max(100, representation.size.width + value.translation.width)
        var newHeight = max(50, representation.size.height + value.translation.height)
        var newX = representation.position.x + value.translation.width / 2
        var newY = representation.position.y + value.translation.height / 2
        
        // Snap to grid if enabled
        if snapToGrid {
            newX = snapToGrid(newX - representation.size.width / 2, gridSize: gridSize) + representation.size.width / 2
            newY = snapToGrid(newY - representation.size.height / 2, gridSize: gridSize) + representation.size.height / 2
            newWidth = snapToGrid(newWidth, gridSize: gridSize)
            newHeight = snapToGrid(newHeight, gridSize: gridSize)
        }
        
        // Update size and position
        if newWidth > minWidth {
            representation.size.width = newWidth
            representation.position.x = newX
        }
        if newHeight > minHeight {
            representation.size.height = newHeight
            representation.position.y = newY
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text(typeString)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Text(representation.name)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Divider()
                    .foregroundStyle(.black)
            }
            VStack {
                VStack(alignment: .leading) {
                    ForEach(representation.attributes) { attribute in
                        Text(
                            "\(getAccessMofifier(attribute.access)) \(attribute.name): \(attribute.type)"
                        )
                        .font(.caption2)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 12)
                    }
                    Divider()
                        .foregroundStyle(.black)
                }
                VStack(alignment: .leading) {
                    ForEach(representation.functions, id: \.id) { function in
                        DisclosureGroup(
                            "\(getAccessMofifier(function.access)) \(function.name): \(function.returnType)"
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
        .frame(width: representation.size.width)
        .frame(minWidth: 100)
        .frame(minHeight: representation.size.height, alignment: .top)
        .background(backgroundColor)
        .border(width: 1, edges: [.bottom, .top, .leading, .trailing], color: .black)
        .overlay(
            Group {
                if isSelected {
                    //top leading
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    topLeadingHandle(value)
                                }
                        )
                        .position(x: 0, y: 0)
                    //top trailing
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    topTrailingHandle(value)
                                }
                        )
                        .position(x: representation.size.width, y: 0)
                    //bottom leading
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    bottomLeadingHandle(value)
                                }
                        )
                        .position(x: 0, y: representation.size.height)
                    //bottom trailing
                    handleView
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    bottomTrailingHandle(value)
                                }
                        )
                        .position(x: representation.size.width, y: representation.size.height)
                }
            }
        )
        .shadow(radius: 10, x: 10, y: 10)
        .position(representation.position)
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
