//
//  ObservedObjectDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - ObservedObject Demo
struct ObservedObjectDemo: View {
    // @ObservedObject - External reference to an observable object
    // Uses Combine: Yes
    @ObservedObject var formData = FormData()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@ObservedObject",
                description: "For observing an external ObservableObject",
                usesCombine: true,
                scope: "External reference"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Enter text", text: $formData.text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Text("You typed: \(formData.text)")
                    .padding(.top, 10)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @ObservedObject")
            
            Text("Use @ObservedObject when your view needs to observe an ObservableObject that's created and owned elsewhere. The view will update when @Published properties of the object change.")
                .padding(.horizontal)
            
            Text("Unlike @StateObject, @ObservedObject doesn't own the object's lifecycle, so the object may be recreated when the view redraws.")
                .padding(.horizontal)
                .padding(.top, 5)
                
            SectionTitle(title: "Comparison with @StateObject")
            
            VStack(alignment: .leading, spacing: 10) {
                Text("• @ObservedObject: Reference to external object")
                Text("• @StateObject: View owns the object")
                Text("• Use @StateObject when creating the object")
                Text("• Use @ObservedObject when receiving the object")
            }
            .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            class FormData: ObservableObject {
                @Published var text = ""
            }
            
            // Parent creates and owns the object
            struct ParentView: View {
                @StateObject private var formData = FormData()
                
                var body: some View {
                    VStack {
                        ChildView(formData: formData)
                    }
                }
            }
            
            // Child receives and observes the object
            struct ChildView: View {
                @ObservedObject var formData: FormData
                
                var body: some View {
                    TextField("Enter text", text: $formData.text)
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
