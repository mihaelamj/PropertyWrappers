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
    
    @State private var showCopiedMessage = false
    @State private var triggerParticles = false
    
    private var screenWidth: CGFloat {
        #if os(iOS)
        return UIScreen.main.bounds.width
        #elseif os(macOS)
        return NSScreen.main?.frame.width ?? 800 // Fallback width
        #else
        return 800 // Default fallback
        #endif
    }
    
    // Action to copy code to clipboard
    private func copyToClipboard() {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
        #else
        UIPasteboard.general.string = code
        #endif
        
        // Trigger the copied message and particles
        withAnimation {
            showCopiedMessage = true
            triggerParticles = true
        }
        
        // Hide the message after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showCopiedMessage = false
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
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
                .buttonStyle(.plain)
                .padding(.top, 8)
                .padding(.trailing, 16)
                
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
            
            // Copied toolbar
            if showCopiedMessage {
                Text("Copied")
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .transition(.opacity)
                    .padding(.top, 40) // Position below button
                    .padding(.trailing, 16)
            }
            
            // Particle effect
            if triggerParticles {
                ParticleEffect()
                    .frame(width: 50, height: 50)
                    .background(Color.red)
                    .position(x: screenWidth - 40, y: 20) // Position near button
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            triggerParticles = false // Reset after short duration
                        }
                    }
            }
        }
    }
}
