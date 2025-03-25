//
//  BindingDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - Binding Demo
struct BindingDemo: View {
    // @State provides source of truth
    @State private var text = "Edit this text"
    @State private var toggleValue = false
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Binding",
                description: "For data passed from a parent view",
                usesCombine: false,
                scope: "Parent to child"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                Text("Parent value: \(text)")
                    .font(.headline)
                
                // Child view that receives binding
                BindingChildView(text: $text, isOn: $toggleValue)
                
                Text("Toggle status: \(toggleValue ? "On" : "Off")")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Binding")
            
            Text("Use @Binding when you need to share state between a parent view and child view, allowing the child to modify the parent's state. The binding creates a two-way connection.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            // Parent view
            struct ParentView: View {
                @State private var text = "Hello"
                
                var body: some View {
                    VStack {
                        Text("Value: \\(text)")
                        ChildView(text: $text)
                    }
                }
            }
            
            // Child view
            struct ChildView: View {
                @Binding var text: String
                
                var body: some View {
                    TextField("Edit text", text: $text)
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

// Child view that uses @Binding
struct BindingChildView: View {
    // @Binding - Reference to state stored elsewhere
    // Uses Combine: No
    @Binding var text: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Child View")
                .font(.headline)
            
            TextField("Edit here", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Toggle("Toggle value", isOn: $isOn)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}
