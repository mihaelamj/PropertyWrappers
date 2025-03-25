//
//  TaskEditorView.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

// Child view using @Bindable with a TaskModel
@available(iOS 17.0, macOS 14.0, *)
struct TaskEditorView: View {
    // @Bindable - Creates bindings to Observable properties
    // Uses Combine: No (uses Observation framework)
    @Bindable var task: TaskModel
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Task title", text: $task.title)
                .textFieldStyle(.roundedBorder)
            
            TextField("Notes", text: $task.notes)
                .textFieldStyle(.roundedBorder)
            
            Picker("Priority", selection: $task.priority) {
                Text("Low").tag(TaskModel.Priority.low)
                Text("Medium").tag(TaskModel.Priority.medium)
                Text("High").tag(TaskModel.Priority.high)
            }
            .pickerStyle(.segmented)
            
            Toggle("Completed", isOn: $task.isCompleted)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}
