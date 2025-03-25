//
//  TaskModel.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import Foundation

// Class for @Bindable demo (iOS 17+)
@Observable class TaskModel {
    var title = ""
    var notes = ""
    var priority = Priority.medium
    var isCompleted = false
    
    enum Priority {
        case low, medium, high
    }
}
