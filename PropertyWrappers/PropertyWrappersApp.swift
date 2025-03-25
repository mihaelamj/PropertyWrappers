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

// MARK: - Models

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

// Form data for @ObservedObject demo
class FormData: ObservableObject {
    @Published var text = ""
}

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

// MARK: - Content View
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

// MARK: - Helper Views

struct InfoCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct PropertyWrapperHeader: View {
    let title: String
    let description: String
    let usesCombine: Bool
    let scope: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Label(
                    usesCombine ? "Uses Combine Framework" : "No Combine Framework dependency",
                    systemImage: usesCombine ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
                .foregroundColor(usesCombine ? .green : .gray)
                
                Label("Scope: \(scope)", systemImage: "scope")
            }
            .font(.callout)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(.bottom)
    }
}

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
        }
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 5)
    }
}

struct UnsupportedView: View {
    let feature: String
    let requirement: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .padding()
            
            Text("\(feature) Not Available")
                .font(.title)
                .fontWeight(.bold)
            
            Text("This feature requires \(requirement)")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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

// MARK: - Binding Demo
struct BindingDemo: View {
    // @State provides source of truth
    @State private var text = "Edit this text"
    @State private var toggleValue = false
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Binding",
                description: "For data passed from a parent view",
                usesCombine: false,
                scope: "Parent to child"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                Text("Parent value: \(text)")
                    .font(.headline)
                
                // Child view that receives binding
                BindingChildView(text: $text, isOn: $toggleValue)
                
                Text("Toggle status: \(toggleValue ? "On" : "Off")")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Binding")
            
            Text("Use @Binding when you need to share state between a parent view and child view, allowing the child to modify the parent's state. The binding creates a two-way connection.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            // Parent view
            struct ParentView: View {
                @State private var text = "Hello"
                
                var body: some View {
                    VStack {
                        Text("Value: \\(text)")
                        ChildView(text: $text)
                    }
                }
            }
            
            // Child view
            struct ChildView: View {
                @Binding var text: String
                
                var body: some View {
                    TextField("Edit text", text: $text)
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

// Child view that uses @Binding
struct BindingChildView: View {
    // @Binding - Reference to state stored elsewhere
    // Uses Combine: No
    @Binding var text: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Child View")
                .font(.headline)
            
            TextField("Edit here", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Toggle("Toggle value", isOn: $isOn)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

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

// MARK: - ObservedObject Demo
struct ObservedObjectDemo: View {
    // @ObservedObject - External reference to an observable object
    // Uses Combine: Yes
    @ObservedObject var formData = FormData()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@ObservedObject",
                description: "For observing an external ObservableObject",
                usesCombine: true,
                scope: "External reference"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Enter text", text: $formData.text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Text("You typed: \(formData.text)")
                    .padding(.top, 10)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @ObservedObject")
            
            Text("Use @ObservedObject when your view needs to observe an ObservableObject that's created and owned elsewhere. The view will update when @Published properties of the object change.")
                .padding(.horizontal)
            
            Text("Unlike @StateObject, @ObservedObject doesn't own the object's lifecycle, so the object may be recreated when the view redraws.")
                .padding(.horizontal)
                .padding(.top, 5)
                
            SectionTitle(title: "Comparison with @StateObject")
            
            VStack(alignment: .leading, spacing: 10) {
                Text("• @ObservedObject: Reference to external object")
                Text("• @StateObject: View owns the object")
                Text("• Use @StateObject when creating the object")
                Text("• Use @ObservedObject when receiving the object")
            }
            .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            class FormData: ObservableObject {
                @Published var text = ""
            }
            
            // Parent creates and owns the object
            struct ParentView: View {
                @StateObject private var formData = FormData()
                
                var body: some View {
                    VStack {
                        ChildView(formData: formData)
                    }
                }
            }
            
            // Child receives and observes the object
            struct ChildView: View {
                @ObservedObject var formData: FormData
                
                var body: some View {
                    TextField("Enter text", text: $formData.text)
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - EnvironmentObject Demo
struct EnvironmentObjectDemo: View {
    // @EnvironmentObject - Global observed object from environment
    // Uses Combine: Yes
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@EnvironmentObject",
                description: "For globally accessible shared state",
                usesCombine: true,
                scope: "App-wide"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 20) {
                Text("Global counter: \(dataStore.counter)")
                    .font(.title)
                
                Button("Increment global counter") {
                    dataStore.incrementCounter()
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                
                Text("Login State: \(dataStore.isLoggedIn ? "Logged In" : "Logged Out")")
                    .font(.headline)
                    .padding(.vertical)
                
                if dataStore.isLoggedIn {
                    Button("Log Out") {
                        dataStore.logout()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Button("Log In") {
                        dataStore.login()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @EnvironmentObject")
            
            Text("Use @EnvironmentObject for app-wide state that needs to be accessed by many views throughout your app. It's injected into the environment at a high level and can be accessed by any child view without passing it explicitly.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            // 1. Create the object
            class AppState: ObservableObject {
                @Published var isLoggedIn = false
            }
            
            // 2. Inject it into the environment
            @main
            struct MyApp: App {
                @StateObject private var appState = AppState()
                
                var body: some Scene {
                    WindowGroup {
                        ContentView()
                            .environmentObject(appState)
                    }
                }
            }
            
            // 3. Access it in any child view
            struct ProfileView: View {
                @EnvironmentObject var appState: AppState
                
                var body: some View {
                    if appState.isLoggedIn {
                        Text("Welcome back!")
                    } else {
                        Text("Please log in")
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Published Demo
struct PublishedDemo: View {
    // Uses a StateObject with @Published properties
    @StateObject private var dataStore = DataStore()
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@Published",
                description: "Publishes changes from ObservableObject properties",
                usesCombine: true,
                scope: "Property of ObservableObject"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Username", text: $dataStore.username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Text("You entered: \(dataStore.username)")
                    .padding(.vertical)
                
                Divider()
                
                Text("Counter: \(dataStore.counter)")
                    .font(.headline)
                    .padding(.vertical)
                
                Button("Increment") {
                    dataStore.incrementCounter()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @Published")
            
            Text("Use @Published for properties inside an ObservableObject that should trigger view updates when they change. It automatically creates a publisher for the property using the Combine framework.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            import Combine
            
            class UserSettings: ObservableObject {
                // These properties will publish changes to observers
                @Published var username = ""
                @Published var isLoggedIn = false
                @Published var theme = "light"
                
                // This won't trigger view updates (no @Published)
                var lastLoginDate: Date? = nil
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - AppStorage Demo
struct AppStorageDemo: View {
    // @AppStorage - Persistent storage in UserDefaults
    // Uses Combine: No
    @AppStorage("username") private var username = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("launchCount") private var launchCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@AppStorage",
                description: "For persisting values in UserDefaults",
                usesCombine: false,
                scope: "App-wide storage"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding(.horizontal)
                
                HStack {
                    Text("Launch count:")
                    Spacer()
                    Text("\(launchCount)")
                        .fontWeight(.bold)
                    
                    Button("Increment") {
                        launchCount += 1
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                Button("Reset All") {
                    username = ""
                    isDarkMode = false
                    launchCount = 0
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @AppStorage")
            
            Text("Use @AppStorage for small pieces of data that need to persist between app launches. It's a wrapper around UserDefaults that automatically updates the UI when values change.")
                .padding(.horizontal)
            
            Text("Best for: user preferences, settings, and small pieces of app state.")
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.top, 5)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct SettingsView: View {
                // String value with key "username"
                @AppStorage("username") private var username = ""
                
                // Boolean value with key "notifications_enabled"
                @AppStorage("notifications_enabled") private var notificationsEnabled = true
                
                // Integer value with key "theme_style"
                @AppStorage("theme_style") private var themeStyle = 0
                
                var body: some View {
                    Form {
                        TextField("Username", text: $username)
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        Picker("Theme", selection: $themeStyle) {
                            Text("Light").tag(0)
                            Text("Dark").tag(1)
                            Text("System").tag(2)
                        }
                    }
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

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

// MARK: - FocusState Demo
struct FocusStateDemo: View {
    enum Field: Hashable {
        case username
        case password
    }
    
    @State private var username = ""
    @State private var password = ""
    // @FocusState - Tracks focus state in forms
    // Uses Combine: No
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 20) {
            PropertyWrapperHeader(
                title: "@FocusState",
                description: "For managing focus in forms and text fields",
                usesCombine: false,
                scope: "Form field focus"
            )
            
            SectionTitle(title: "Example Usage")
            
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil
                    }
                
                HStack(spacing: 10) {
                    Button("Focus Username") {
                        focusedField = .username
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Focus Password") {
                        focusedField = .password
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Clear Focus") {
                        focusedField = nil
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top)
                
                if let field = focusedField {
                    Text("Focused field: \(field == .username ? "Username" : "Password")")
                        .padding(.top)
                } else {
                    Text("No field focused")
                        .padding(.top)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            SectionTitle(title: "When to use @FocusState")
            
            Text("Use @FocusState to programmatically control which view has keyboard focus. It's useful for form navigation, validation, and improving user experience by automatically moving focus between fields.")
                .padding(.horizontal)
            
            SectionTitle(title: "Implementation")
            
            CodeBlock(code: """
            struct LoginForm: View {
                enum Field: Hashable {
                    case email
                    case password
                }
                
                @State private var email = ""
                @State private var password = ""
                @FocusState private var focusedField: Field?
                
                var body: some View {
                    VStack {
                        TextField("Email", text: $email)
                            .focused($focusedField, equals: .email)
                            .textContentType(.emailAddress)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .textContentType(.password)
                            .submitLabel(.done)
                            .onSubmit {
                                login()
                            }
                            
                        Button("Log In") {
                            login()
                        }
                    }
                    .onAppear {
                        // Auto-focus the email field when view appears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.focusedField = .email
                        }
                    }
                }
                
                private func login() {
                    // Clear focus when logging in
                    focusedField = nil
                    // Login logic here...
                }
            }
            """)
        }
        .padding(.bottom, 40)
    }
}

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

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStore())
    }
}
