//
//  ClassView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ClassView: View {
    var className: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .background(.clear)
                    .frame(height: 30)
                    .border(Color.black, width: 1)
                Text(className)
                    .font(.caption)
                    .foregroundStyle(Color.black)
            }
            Rectangle()
                .background(.clear)
                .frame(height: 100)
                .border(Color.black, width: 1)
        }
        .frame(width: 100)
    }
}

#Preview {
    ClassView(className: "ClassViewModel")
}
