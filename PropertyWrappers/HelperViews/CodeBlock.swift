//
//  CodeBlock.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
        }
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
