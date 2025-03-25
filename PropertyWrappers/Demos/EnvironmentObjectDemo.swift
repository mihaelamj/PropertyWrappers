//
//  EnvironmentObjectDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - EnvironmentObject Demo
struct EnvironmentObjectDemo: View {
    // @EnvironmentObject - Global observed object from environment
    // Uses Combine: Yes
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@EnvironmentObject",
                description: "For globally accessible shared state",
                usesCombine: true,
                scope: "App-wide"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 20) {
                Text("Global counter: \(dataStore.counter)")
                    .font(.title)
                
                Button("Increment global counter") {
                    dataStore.incrementCounter()
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                
                Text("Login State: \(dataStore.isLoggedIn ? "Logged In" : "Logged Out")")
                    .font(.headline)
                    .padding(.vertical)
                
                if dataStore.isLoggedIn {
                    Button("Log Out") {
                        dataStore.logout()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Button("Log In") {
                        dataStore.login()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @EnvironmentObject")
            
            Text("Use @EnvironmentObject for app-wide state that needs to be accessed by many views throughout your app. It's injected into the environment at a high level and can be accessed by any child view without passing it explicitly.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            // 1. Create the object
            class AppState: ObservableObject {
                @Published var isLoggedIn = false
            }
            
            // 2. Inject it into the environment
            @main
            struct MyApp: App {
                @StateObject private var appState = AppState()
                
                var body: some Scene {
                    WindowGroup {
                        ContentView()
                            .environmentObject(appState)
                    }
                }
            }
            
            // 3. Access it in any child view
            struct ProfileView: View {
                @EnvironmentObject var appState: AppState
                
                var body: some View {
                    if appState.isLoggedIn {
                        Text("Welcome back!")
                    } else {
                        Text("Please log in")
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
