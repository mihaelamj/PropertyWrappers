//
//  ContentView.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

struct ContentView: View {
    // Navigation State
    @State private var selection: String? = nil
    
    // Global Data
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section(header: Text("State Management")) {
                    NavigationLink("@State", value: "@State")
                    NavigationLink("@Binding", value: "@Binding")
                    NavigationLink("@StateObject", value: "@StateObject")
                }
                
                Section(header: Text("Observable Objects")) {
                    NavigationLink("@ObservedObject", value: "@ObservedObject")
                    NavigationLink("@EnvironmentObject", value: "@EnvironmentObject")
                    NavigationLink("@Published", value: "@Published")
                }
                
                Section(header: Text("Persistence")) {
                    NavigationLink("@AppStorage", value: "@AppStorage")
                    NavigationLink("@SceneStorage", value: "@SceneStorage")
                }
                
                Section(header: Text("Environment & Focus")) {
                    NavigationLink("@Environment", value: "@Environment")
                    NavigationLink("@FocusState", value: "@FocusState")
                }
                
                Section(header: Text("iOS 17+")) {
                    NavigationLink("@Bindable", value: "@Bindable")
                }
            }
            .navigationTitle("Property Wrappers")
        } detail: {
            if let selection = selection {
                detailView(for: selection)
            } else {
                welcomeView
            }
        }
    }
    
    // Welcome view when no selection
    var welcomeView: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .padding()
            
            Text("SwiftUI Property Wrappers")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Select a property wrapper from the sidebar to see examples and learn how it works.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.secondary)
            
            InfoCard(
                title: "Learn By Example",
                description: "Each demo shows practical usage with code examples",
                icon: "hand.tap"
            )
            
            InfoCard(
                title: "Compare Wrappers",
                description: "Understand which wrapper to use for different scenarios",
                icon: "arrow.left.and.right.text.horizontal"
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Route to the appropriate detail view
    @ViewBuilder
    func detailView(for selection: String) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                switch selection {
                case "@State":
                    StateDemo()
                case "@Binding":
                    BindingDemo()
                case "@StateObject":
                    StateObjectDemo()
                case "@ObservedObject":
                    ObservedObjectDemo()
                case "@EnvironmentObject":
                    EnvironmentObjectDemo()
                case "@Published":
                    PublishedDemo()
                case "@AppStorage":
                    AppStorageDemo()
                case "@SceneStorage":
                    SceneStorageDemo()
                case "@Environment":
                    EnvironmentDemo()
                case "@FocusState":
                    FocusStateDemo()
                case "@Bindable":
                    if #available(iOS 17, macOS 14, *) {
                        BindableDemo()
                    } else {
                        UnsupportedView(feature: "@Bindable", requirement: "iOS 17 or macOS 14")
                    }
                default:
                    Text("Select a property wrapper")
                }
            }
        }
        .navigationTitle(selection)
    }
}
