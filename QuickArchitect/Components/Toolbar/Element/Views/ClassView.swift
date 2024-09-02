//
//  ClassView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ClassView: View {
    @State private var anchor: UnitPoint = .topLeading
    @State private var viewPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var viewSize: CGSize = CGSize(width: 100, height: 100)
    @State private var viewScaleTemp: CGSize = CGSize(width: 1, height: 1)
    var isSelected: Bool = false
    private let minSize: CGSize = CGSize(width: 30, height: 30)
    private let translationFactor: CGFloat = 0.5
    
    var className: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: viewSize.height)
                    .border(Color.black, width: 1)
                VStack {
                    Text("<< class >>")
                        .font(.caption)
                        .foregroundStyle(Color.black)
                    Text(className)
                        .font(.caption)
                        .foregroundStyle(Color.black)
                }
            }
        }
        .background(.white)
        .frame(width: viewSize.width)
        .scaleEffect(CGSize(width: viewScaleTemp.width, height: viewScaleTemp.height), anchor: anchor)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        // top edge
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .border(width: 2/viewScaleTemp.width, edges: [.top], color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: 0, height: gesture.translation.height), targetAnchor: .bottomTrailing)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .bottomTrailing)
                            })
                    )
            }
        }
        // bottom edge
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .border(width: 2/viewScaleTemp.width, edges: [.bottom], color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: 0, height: gesture.translation.height), targetAnchor: .topLeading)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .topLeading)
                            })
                    )
            }
        }
        // leading edge
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .border(width: 2/viewScaleTemp.width, edges: [.leading], color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: gesture.translation.width, height: 0), targetAnchor: .bottomTrailing)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .bottomTrailing)
                            })
                    )
            }
        }
        // trailing edge
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .border(width: 2/viewScaleTemp.width, edges: [.trailing], color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: gesture.translation.width, height: 0), targetAnchor: .topLeading)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .topLeading)
                            })
                    )
            }
        }
        // top leading corner
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: 7/viewScaleTemp.width, height: 7/viewScaleTemp.height), anchor: .topLeading, color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .bottomTrailing)
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .bottomTrailing)
                            })
                    )
            }
        }
        // top trailing corner
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: 7/viewScaleTemp.width, height: 7/viewScaleTemp.height), anchor: .topTrailing, color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .bottomLeading)
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .bottomLeading)
                            })
                    )
            }
        }
        // bottom leading corner
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: 7/viewScaleTemp.width, height: 7/viewScaleTemp.height), anchor: .bottomLeading, color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .topTrailing)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .topTrailing)
                            })
                    )
            }
        }
        // bottom trailing corner
        .overlay {
            if isSelected {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: 7/viewScaleTemp.width, height: 7/viewScaleTemp.height), anchor: .bottomTrailing, color: .accent)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .topLeading)
                            
                        })
                            .onEnded({gesture in
                                onDragGestureEnded(currentAnchor: .topLeading)
                            })
                    )
            }
        }
    }
    
    private func onDragGestureChanged(_ translation: CGSize, targetAnchor: UnitPoint) {
        anchor = targetAnchor
        
        let signX: CGFloat = targetAnchor.x == 0 ? 1 : -1
        let signY: CGFloat = targetAnchor.y == 0 ? 1 : -1
        
        let newHeight = max(minSize.height, viewSize.height + signY * translation.height * translationFactor)
        
        viewScaleTemp.height = newHeight / viewSize.height
        
        let newWidth = max(minSize.width, viewSize.width + signX * translation.width * translationFactor)
        viewScaleTemp.width = newWidth / viewSize.width
    }
    
    private func onDragGestureEnded(currentAnchor: UnitPoint) {
        
        anchor = .center
        
        let signX: CGFloat = currentAnchor.x == 0 ? -1 : 1
        let signY: CGFloat = currentAnchor.y == 0 ? -1 : 1
        
        viewPosition.x = viewPosition.x + signX * viewSize.width * (1-viewScaleTemp.width)
        viewSize.width = viewSize.width * viewScaleTemp.width
        viewScaleTemp.width = 1
        
        viewPosition.y = viewPosition.y + signY * viewSize.height * (1-viewScaleTemp.height)
        viewSize.height = viewSize.height * viewScaleTemp.height
        viewScaleTemp.height = 1
    }
}
