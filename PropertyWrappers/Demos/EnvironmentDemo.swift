//
//  EnvironmentDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - Environment Demo
struct EnvironmentDemo: View {
    // @Environment - System and environment values
    // Uses Combine: No
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Environment",
                description: "For accessing system and environment values",
                usesCombine: false,
                scope: "System environment"
            )
            
            SectionTitle(title: "Current Environment Values")
            
            VStack(spacing: 10) {
                HStack {
                    Text("Color scheme:")
                    Spacer()
                    Text(colorScheme == .dark ? "Dark" : "Light")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Size class:")
                    Spacer()
                    Text(horizontalSizeClass == .compact ? "Compact" : "Regular")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Locale identifier:")
                    Spacer()
                    Text(locale.identifier)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Calendar:")
                    Spacer()
                    Text(String(describing: calendar.identifier))
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "Common Environment Values")
            
            VStack(alignment: .leading, spacing: 10) {
                Text("• colorScheme: Light or dark mode")
                Text("• sizeCategory: Dynamic Type size")
                Text("• locale: User's region settings")
                Text("• layoutDirection: Left-to-right or right-to-left")
                Text("• presentationMode: Presentation state")
                Text("• horizontalSizeClass: Compact or regular width")
                Text("• verticalSizeClass: Compact or regular height")
            }
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Environment")
            
            Text("Use @Environment to access system-provided values or to read values that have been set higher up in the view hierarchy. It's useful for adapting your UI to system conditions or custom environment values.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct AdaptiveView: View {
                // Read system environment values
                @Environment(\\.colorScheme) var colorScheme
                @Environment(\\.sizeCategory) var sizeCategory
                @Environment(\\.horizontalSizeClass) var horizontalSizeClass
                @Environment(\\.presentationMode) var presentationMode
                
                // Custom environment values
                @Environment(\\.myCustomTheme) var theme
                
                var body: some View {
                    VStack {
                        // Adapt to dark/light mode
                        if colorScheme == .dark {
                            DarkModeContent()
                        } else {
                            LightModeContent()
                        }
                        
                        // Adapt to device size
                        if horizontalSizeClass == .compact {
                            CompactLayoutView()
                        } else {
                            RegularLayoutView()
                        }
                        
                        // Dismiss the view
                        Button("Dismiss") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            
            // Define a custom environment key
            struct MyThemeKey: EnvironmentKey {
                static let defaultValue = "default"
            }
            
            // Extend EnvironmentValues
            extension EnvironmentValues {
                var myCustomTheme: String {
                    get { self[MyThemeKey.self] }
                    set { self[MyThemeKey.self] = newValue }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
