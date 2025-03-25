//
//  SceneStorageDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI


// MARK: - SceneStorage Demo
struct SceneStorageDemo: View {
    // @SceneStorage - State preservation for scene sessions
    // Uses Combine: No
    @SceneStorage("draftText") private var draftText = ""
    @SceneStorage("selectedTab") private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@SceneStorage",
                description: "For persisting state across scene sessions",
                usesCombine: false,
                scope: "Scene-specific storage"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TabView(selection: $selectedTab) {
                    VStack {
                        Text("Draft")
                            .font(.headline)
                        
                        TextEditor(text: $draftText)
                            .frame(height: 100)
                            .padding(4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("This text persists when app is backgrounded")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .tabItem {
                        Label("Draft", systemImage: "pencil")
                    }
                    .tag(0)
                    
                    VStack {
                        Text("Tab selection is preserved")
                            .font(.headline)
                        
                        Text("Try switching tabs and backgrounding the app")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .tabItem {
                        Label("Info", systemImage: "info.circle")
                    }
                    .tag(1)
                }
                .frame(height: 200)
                
                Button("Clear Draft") {
                    draftText = ""
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @SceneStorage")
            
            Text("Use @SceneStorage to preserve UI state when a scene is temporarily backgrounded or suspended. It's automatically restored when the scene returns to the foreground.")
                .padding(.horizontal)
            
            Text("@SceneStorage is ideal for preserving user input, scroll positions, tab selections, and other UI state that would be annoying to lose when an app is temporarily backgrounded.")
                .padding(.horizontal)
                .padding(.top, 5)
            
            SectionTitle(title: "Comparison with @AppStorage")
            
            VStack(alignment: .leading, spacing: 10) {
                Text("• @AppStorage: Persists between app launches (UserDefaults)")
                Text("• @SceneStorage: Persists between scene sessions")
                Text("• @SceneStorage is per-scene, not shared across app")
                Text("• @SceneStorage data is lost when app is terminated")
            }
            .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct NoteEditorView: View {
                // Persists note text when app is backgrounded
                @SceneStorage("current_note_text") private var noteText = ""
                
                // Persists the selected editor mode
                @SceneStorage("editor_mode") private var editorMode = 0
                
                var body: some View {
                    VStack {
                        Picker("Mode", selection: $editorMode) {
                            Text("Edit").tag(0)
                            Text("Preview").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        if editorMode == 0 {
                            TextEditor(text: $noteText)
                        } else {
                            ScrollView {
                                Text(noteText)
                            }
                        }
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}
