//
//  StateObjectDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - StateObject Demo
struct StateObjectDemo: View {
    // @StateObject - View owns the observable object
    // Uses Combine: Yes
    @StateObject private var dataStore = DataStore()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@StateObject",
                description: "For when a view owns an ObservableObject",
                usesCombine: true,
                scope: "View owned"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                Text("Local counter: \(dataStore.counter)")
                    .font(.title)
                
                Button("Increment counter") {
                    dataStore.incrementCounter()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @StateObject")
            
            Text("Use @StateObject when your view needs to create and own an ObservableObject. Unlike @ObservedObject, @StateObject preserves the object's state when the view redraws, ensuring it isn't recreated.")
                .padding(.horizontal)
            
            Text("@StateObject is perfect for view models that should exist as long as the view exists.")
                .padding(.horizontal)
                .padding(.top, 5)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            class ViewModel: ObservableObject {
                @Published var counter = 0
                
                func increment() {
                    counter += 1
                }
            }
            
            struct CounterView: View {
                @StateObject private var viewModel = ViewModel()
                
                var body: some View {
                    VStack {
                        Text("Count: \\(viewModel.counter)")
                        Button("Increment") {
                            viewModel.increment()
                        }
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
