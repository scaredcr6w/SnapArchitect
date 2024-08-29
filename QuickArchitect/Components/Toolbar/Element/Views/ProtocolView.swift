//
//  ProtocolView.swift
//  QuickArchitect
//
//  Created by Anda Levente on 28/08/2024.
//

import SwiftUI

struct ProtocolView: View {
    var protocolName: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(.clear)
                .stroke(.black, lineWidth: 1)
                .frame(height: 30)
            Text(protocolName)
                .font(.caption)
                .foregroundStyle(Color.black)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.black)
        }
        .frame(width: 100)
    }
}

#Preview {
    ProtocolView(protocolName: "ProtocolView")
}
