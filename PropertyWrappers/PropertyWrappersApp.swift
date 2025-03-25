import SwiftUI
import Combine

// MARK: - App Entry Point
@main
struct PropertyWrappersApp: App {
    // @StateObject ensures the model lives as long as the app
    @StateObject private var appViewModel = AppViewModel()
    
    // Environment object that will be available throughout the app
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
        #if os(macOS)
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        #endif
    }
}

// MARK: - Models

// Observable object for @ObservedObject and @StateObject demos
class AppViewModel: ObservableObject {
    // @Published automatically publishes changes to observers
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

// Observable object for @Binding demo
class FormViewModel: ObservableObject {
    @Published var text = ""
}

// Class for @Bindable demo (iOS 17+)
@Observable class NewTaskModel {
    var title = ""
    var notes = ""
    var priority = Priority.medium
    var isCompleted = false
    
    enum Priority {
        case low, medium, high
    }
}

// MARK: - Main Navigation View
struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedWrapper: PropertyWrapper?
    
    enum PropertyWrapper: String, CaseIterable, Identifiable {
        case state = "@State"
        case binding = "@Binding"
        case observedObject = "@ObservedObject"
        case environmentObject = "@EnvironmentObject"
        case stateObject = "@StateObject"
        case published = "@Published"
        case appStorage = "@AppStorage"
        case sceneStorage = "@SceneStorage"
        case environment = "@Environment"
        case focusState = "@FocusState"
        case bindable = "@Bindable"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationSplitView {
            List(PropertyWrapper.allCases, selection: $selectedWrapper) { wrapper in
                NavigationLink(wrapper.rawValue, value: wrapper)
            }
            .navigationTitle("Property Wrappers")
        } detail: {
            if let selectedWrapper = selectedWrapper {
                detailView(for: selectedWrapper)
            } else {
                Text("Select a property wrapper to see its demo")
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    func detailView(for wrapper: PropertyWrapper) -> some View {
        switch wrapper {
        case .state:
            StateDemo()
        case .binding:
            BindingDemo()
        case .observedObject:
            ObservedObjectDemo()
        case .environmentObject:
            EnvironmentObjectDemo()
        case .stateObject:
            StateObjectDemo()
        case .published:
            PublishedDemo()
        case .appStorage:
            AppStorageDemo()
        case .sceneStorage:
            SceneStorageDemo()
        case .environment:
            EnvironmentDemo()
        case .focusState:
            FocusStateDemo()
        case .bindable:
            if #available(iOS 17, macOS 14, *) {
                BindableDemo()
            } else {
                Text("@Bindable requires iOS 17/macOS 14 or later")
            }
        }
    }
}

// MARK: - Individual Demo Views

// @State Demo: Local view state
struct StateDemo: View {
    // @State is for view-local data owned by the view
    @State private var counter = 0
    @State private var sliderValue = 0.5
    @State private var isToggleOn = false
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@State",
                       description: "For simple view-local state that the view owns")
                        
            
            Text("Counter: \(counter)")
                .font(.headline)
            
            Button("Increment") {
                counter += 1
            }
            .buttonStyle(.borderedProminent)
            
            Slider(value: $sliderValue)
                .padding()
            
            Text("Slider value: \(sliderValue, specifier: "%.2f")")
            
            Toggle("Toggle me", isOn: $isToggleOn)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @Binding Demo: Data passed from parent
struct BindingDemo: View {
    @State private var text = "Edit this text"
    @State private var toggleValue = false
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@Binding",
                       description: "For data passed from a parent view")
            
            Text("Parent value: \(text)")
                .font(.headline)
                .padding()
            
            // Child view that receives binding from parent
            BindingChildView(text: $text, isOn: $toggleValue)
            
            Text("Toggle status: \(toggleValue ? "On" : "Off")")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BindingChildView: View {
    // @Binding receives data from parent view
    @Binding var text: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Child View (with @Binding)")
                .font(.headline)
            
            TextField("Edit here", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Toggle("Toggle value", isOn: $isOn)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// @ObservedObject Demo: External reference type
struct ObservedObjectDemo: View {
    // @ObservedObject references an external observable object
    @ObservedObject var viewModel = FormViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@ObservedObject",
                       description: "For observing an external ObservableObject")
            
            Text("@ObservedObject doesn't own the lifecycle")
                .font(.callout)
                .foregroundColor(.secondary)
            
            TextField("Enter something", text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("You typed: \(viewModel.text)")
            
            // Demonstrates that ObservedObject should be passed from parent
            Text("Use @StateObject when the view owns the model")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @EnvironmentObject Demo: Globally available object
struct EnvironmentObjectDemo: View {
    // @EnvironmentObject receives data from the environment
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@EnvironmentObject",
                       description: "For globally accessible state")
            
            Text("Global counter: \(appViewModel.counter)")
                .font(.headline)
            
            Button("Increment global counter") {
                appViewModel.incrementCounter()
            }
            .buttonStyle(.borderedProminent)
            
            Divider()
            
            Text("Login State: \(appViewModel.isLoggedIn ? "Logged In" : "Logged Out")")
                .padding()
            
            if appViewModel.isLoggedIn {
                Button("Log Out") {
                    appViewModel.logout()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Button("Log In") {
                    appViewModel.login()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            
            Text("This value is accessible throughout the app")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @StateObject Demo: View owns the model
struct StateObjectDemo: View {
    // @StateObject is owned by the view and persists through view updates
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@StateObject",
                       description: "For when a view owns an ObservableObject")
            
            Text("Local counter: \(viewModel.counter)")
                .font(.headline)
            
            Button("Increment local counter") {
                viewModel.incrementCounter()
            }
            .buttonStyle(.borderedProminent)
            
            Text("@StateObject ensures the model exists\nas long as the view exists")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("Unlike @ObservedObject, @StateObject\nwon't be recreated when the view redraws")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @Published Demo: Property of ObservableObject
struct PublishedDemo: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@Published",
                       description: "Publishes changes from ObservableObject properties")
            
            Text("@Published lets the view know when\nproperties of ObservableObject change")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Divider()
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("You entered: \(viewModel.username)")
            
            Divider()
            
            Text("Counter: \(viewModel.counter)")
                .font(.headline)
            
            Button("Increment") {
                viewModel.incrementCounter()
            }
            .buttonStyle(.borderedProminent)
            
            CodePreview(code: """
            class AppViewModel: ObservableObject {
                @Published var counter = 0
                @Published var username = ""
                
                func incrementCounter() {
                    counter += 1
                }
            }
            """)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @AppStorage Demo: UserDefaults integration
struct AppStorageDemo: View {
    // @AppStorage persists in UserDefaults
    @AppStorage("username") private var username = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("launchCount") private var launchCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@AppStorage",
                       description: "For persisting values in UserDefaults")
            
            Text("Values persist between app launches")
                .font(.callout)
                .foregroundColor(.secondary)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding(.horizontal)
            
            HStack {
                Text("Launch count:")
                Text("\(launchCount)")
                    .fontWeight(.bold)
                
                Button("Increment") {
                    launchCount += 1
                }
                .buttonStyle(.bordered)
            }
            
            Button("Reset All") {
                username = ""
                isDarkMode = false
                launchCount = 0
            }
            .buttonStyle(.bordered)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @SceneStorage Demo: Scene persistence
struct SceneStorageDemo: View {
    // @SceneStorage persists state across scene sessions
    @SceneStorage("draftText") private var draftText = ""
    @SceneStorage("selectedTab") private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@SceneStorage",
                       description: "For persisting state when scenes are backgrounded")
            
            Text("Values persist when app is backgrounded\nor when using multiple windows")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            TabView(selection: $selectedTab) {
                VStack {
                    Text("Draft Text")
                        .font(.headline)
                    
                    TextEditor(text: $draftText)
                        .frame(height: 100)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("This text will persist when app is backgrounded")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .tabItem {
                    Label("Draft", systemImage: "pencil")
                }
                .tag(0)
                
                VStack {
                    Text("Tab selection is also preserved")
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
            .padding(.vertical)
            
            Button("Clear Draft") {
                draftText = ""
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @Environment Demo: System/environment values
struct EnvironmentDemo: View {
    // @Environment accesses environment values
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@Environment",
                       description: "For accessing system and environment values")
            
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
            .padding(.horizontal)
            
            Divider()
            
            CodePreview(code: """
            @Environment(\\.colorScheme) var colorScheme
            @Environment(\\.horizontalSizeClass) var horizontalSizeClass
            @Environment(\\.locale) var locale
            """)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @FocusState Demo: Focus tracking
struct FocusStateDemo: View {
    enum Field: Hashable {
        case username
        case password
    }
    
    @State private var username = ""
    @State private var password = ""
    // @FocusState tracks text field focus
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@FocusState",
                       description: "For managing focus in forms and text fields")
            
            Text("Manages keyboard focus and field transitions")
                .font(.callout)
                .foregroundColor(.secondary)
            
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
            }
            .padding(.horizontal)
            
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
            
            if let field = focusedField {
                Text("Focused field: \(field == .username ? "Username" : "Password")")
                    .padding(.top)
            } else {
                Text("No field focused")
                    .padding(.top)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// @Bindable Demo (iOS 17+): Using the new Observation framework
@available(iOS 17.0, macOS 14.0, *)
struct BindableDemo: View {
    // Using Observable class from new Observation framework
    @State private var model = NewTaskModel()
    
    var body: some View {
        VStack(spacing: 20) {
            headerView(title: "@Bindable",
                       description: "For binding to Observable classes (iOS 17+)")
            
            Text("Uses the new Observation framework")
                .font(.callout)
                .foregroundColor(.secondary)
            
            // Passing the model to a child view
            TaskEditorView(model: model)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Current task values:")
                    .font(.headline)
                
                Text("Title: \(model.title)")
                Text("Notes: \(model.notes)")
                Text("Priority: \(priorityString(model.priority))")
                Text("Completed: \(model.isCompleted ? "Yes" : "No")")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            CodePreview(code: """
            // Define model with @Observable
            @Observable class NewTaskModel {
                var title = ""
                var notes = ""
                var priority = Priority.medium
                var isCompleted = false
            }
            
            // Use with @Bindable
            struct TaskEditorView: View {
                @Bindable var model: NewTaskModel
                
                var body: some View {
                    TextField("Title", text: $model.title)
                    // Other controls...
                }
            }
            """)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func priorityString(_ priority: NewTaskModel.Priority) -> String {
        switch priority {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct TaskEditorView: View {
    // @Bindable provides bindings to properties of Observable classes
    @Bindable var model: NewTaskModel
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Task title", text: $model.title)
                .textFieldStyle(.roundedBorder)
            
            TextField("Notes", text: $model.notes)
                .textFieldStyle(.roundedBorder)
            
            Picker("Priority", selection: $model.priority) {
                Text("Low").tag(NewTaskModel.Priority.low)
                Text("Medium").tag(NewTaskModel.Priority.medium)
                Text("High").tag(NewTaskModel.Priority.high)
            }
            .pickerStyle(.segmented)
            
            Toggle("Completed", isOn: $model.isCompleted)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Helper Views

struct CodePreview: View {
    let code: String
    
    var body: some View {
        ScrollView {
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
        .frame(height: 150)
    }
}

struct headerView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppViewModel())
    }
}
