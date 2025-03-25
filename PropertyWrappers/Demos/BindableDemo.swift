//
//  BindableDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// MARK: - Bindable Demo (iOS 17+)
@available(iOS 17.0, macOS 14.0, *)
struct BindableDemo: View {
    // @State with Observable class
    @State private var task = TaskModel()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Bindable",
                description: "For binding to Observable classes (iOS 17+)",
                usesCombine: false,
                scope: "Observable framework objects"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 10) {
                TaskEditorView(task: task)
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current task values:")
                        .font(.headline)
                    
                    Text("Title: \(task.title)")
                    Text("Notes: \(task.notes)")
                    Text("Priority: \(priorityString(task.priority))")
                    Text("Completed: \(task.isCompleted ? "Yes" : "No")")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Bindable")
            
            Text("Use @Bindable with the Observation framework (iOS 17+) to create bindings to properties of an Observable class. It replaces the need for ObservableObject and @Published in many cases.")
                .padding(.horizontal)
            
            Text("The Observation framework is more efficient than Combine and doesn't require properties to be marked with a property wrapper.")
                .padding(.horizontal)
                .padding(.top, 5)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            import SwiftUI
            import Observation
            
            // Define model with @Observable
            @Observable class TaskModel {
                var title = ""
                var notes = ""
                var priority = Priority.medium
                var isCompleted = false
                
                enum Priority {
                    case low, medium, high
                }
            }
            
            // Parent view that owns the model
            struct TaskView: View {
                @State private var task = TaskModel()
                
                var body: some View {
                    VStack {
                        // Pass to child view
                        TaskEditorView(task: task)
                        
                        // Use directly in this view
                        Text("Title: \\(task.title)")
                    }
                }
            }
            
            // Child view that uses @Bindable
            struct TaskEditorView: View {
                @Bindable var task: TaskModel
                
                var body: some View {
                    Form {
                        TextField("Title", text: $task.title)
                        TextField("Notes", text: $task.notes)
                        Toggle("Completed", isOn: $task.isCompleted)
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
    
    private func priorityString(_ priority: TaskModel.Priority) -> String {
        switch priority {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}
