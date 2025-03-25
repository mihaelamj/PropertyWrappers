//
//  PublishedDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - Published Demo
struct PublishedDemo: View {
    // Uses a StateObject with @Published properties
    @StateObject private var dataStore = DataStore()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Published",
                description: "Publishes changes from ObservableObject properties",
                usesCombine: true,
                scope: "Property of ObservableObject"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Username", text: $dataStore.username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Text("You entered: \(dataStore.username)")
                    .padding(.vertical)
                
                Divider()
                
                Text("Counter: \(dataStore.counter)")
                    .font(.headline)
                    .padding(.vertical)
                
                Button("Increment") {
                    dataStore.incrementCounter()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Published")
            
            Text("Use @Published for properties inside an ObservableObject that should trigger view updates when they change. It automatically creates a publisher for the property using the Combine framework.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            import Combine
            
            class UserSettings: ObservableObject {
                // These properties will publish changes to observers
                @Published var username = ""
                @Published var isLoggedIn = false
                @Published var theme = "light"
                
                // This won't trigger view updates (no @Published)
                var lastLoginDate: Date? = nil
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
