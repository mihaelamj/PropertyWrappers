//
//  DataStore.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import Foundation

// Observable object for demonstrations
class DataStore: ObservableObject {
    // @Published - Property that publishes changes
    // Uses Combine: Yes
    @Published var counter = 0
    @Published var username = ""
    @Published var isLoggedIn = false
    
    func incrementCounter() {
        counter += 1
    }
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
    }
}
