import SwiftUI
import Combine

// MARK: - App Entry Point

@main
struct PropertyWrappersApp: App {
    // @StateObject - View owns the observable object
    // Uses Combine: Yes
    @StateObject private var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStore())
    }
}
