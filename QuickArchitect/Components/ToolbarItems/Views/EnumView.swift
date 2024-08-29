//
//  EnumView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct EnumView: View {
    var enumName: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 30)
                    .border(Color.black, width: 1)
                VStack {
                    Text("<< enumeration >>")
                        .font(.caption)
                        .foregroundStyle(Color.black)
                    Text(enumName)
                        .font(.caption)
                        .foregroundStyle(Color.black)
                }
            }
            Rectangle()
                .fill(.clear)
                .frame(height: 100)
                .border(Color.black, width: 1)
        }
        .frame(width: 100)
    }
}

#Preview {
    EnumView(enumName: "EnumView")
}
