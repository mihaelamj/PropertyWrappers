//
//  StateDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - State Demo
struct StateDemo: View {
    // @State - View-local state
    // Uses Combine: No
    @State private var counter = 0
    @State private var sliderValue = 0.5
    @State private var isToggleOn = false
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@State",
                description: "For simple view-local state that the view owns",
                usesCombine: false,
                scope: "View-local"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                Text("Counter: \(counter)")
                    .font(.title)
                
                Button("Increment") {
                    counter += 1
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                
                Slider(value: $sliderValue)
                    .padding()
                
                Text("Slider value: \(sliderValue, specifier: "%.2f")")
                
                Divider()
                
                Toggle("Toggle me", isOn: $isToggleOn)
                    .padding(.horizontal)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @State")
            
            Text("Use @State for simple value types like Int, Bool, or String that are local to a view and not shared with other views. SwiftUI will automatically redraw the view when the state changes.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct CounterView: View {
                @State private var counter = 0
                
                var body: some View {
                    VStack {
                        Text("Count: \\(counter)")
                        Button("Increment") {
                            counter += 1
                        }
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
