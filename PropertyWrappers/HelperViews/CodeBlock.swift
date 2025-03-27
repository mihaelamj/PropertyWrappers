//
//  CodeBlock.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

struct CodeBlock: View {
    let code: String
    let language = ProgrammingLanguage.swift
    
    // Action to copy code to clipboard
    private func copyToClipboard() {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
        #else
        UIPasteboard.general.string = code
        #endif
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            // Copy button with image and text
            Button(action: copyToClipboard) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.on.clipboard")
                    Text("Copy")
                }
                .foregroundColor(.gray)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(4)
            }
            .buttonStyle(.plain) // Keeps it minimal
            .padding(.top, 8)
            .padding(.trailing, 16) // Increased from 8 to 16 for bigger gap
            
            // Code display
            ScrollView(.horizontal, showsIndicators: false) {
                Text(AttributedString(code: code, language: language))
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
            .background(Color.black.opacity(0.05))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}

struct CodeBlockOld: View {
    let code: String
    let language = ProgrammingLanguage.swift
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(AttributedString(code: code, language: language))
                .font(.system(.body, design: .monospaced))
                .padding()
        }
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
