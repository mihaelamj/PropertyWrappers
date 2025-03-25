//
//  AppStorageDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - AppStorage Demo
struct AppStorageDemo: View {
    // @AppStorage - Persistent storage in UserDefaults
    // Uses Combine: No
    @AppStorage("username") private var username = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("launchCount") private var launchCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@AppStorage",
                description: "For persisting values in UserDefaults",
                usesCombine: false,
                scope: "App-wide storage"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding(.horizontal)
                
                HStack {
                    Text("Launch count:")
                    Spacer()
                    Text("\(launchCount)")
                        .fontWeight(.bold)
                    
                    Button("Increment") {
                        launchCount += 1
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                Button("Reset All") {
                    username = ""
                    isDarkMode = false
                    launchCount = 0
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @AppStorage")
            
            Text("Use @AppStorage for small pieces of data that need to persist between app launches. It's a wrapper around UserDefaults that automatically updates the UI when values change.")
                .padding(.horizontal)
            
            Text("Best for: user preferences, settings, and small pieces of app state.")
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.top, 5)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct SettingsView: View {
                // String value with key "username"
                @AppStorage("username") private var username = ""
                
                // Boolean value with key "notifications_enabled"
                @AppStorage("notifications_enabled") private var notificationsEnabled = true
                
                // Integer value with key "theme_style"
                @AppStorage("theme_style") private var themeStyle = 0
                
                var body: some View {
                    Form {
                        TextField("Username", text: $username)
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        Picker("Theme", selection: $themeStyle) {
                            Text("Light").tag(0)
                            Text("Dark").tag(1)
                            Text("System").tag(2)
                        }
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
