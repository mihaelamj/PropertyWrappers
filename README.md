# PropertyWrappers

A comprehensive SwiftUI demo application showcasing various property wrappers in SwiftUI. This app serves as an educational resource and reference for understanding how different property wrappers work in SwiftUI applications.

## Overview

This application demonstrates the usage and behavior of different SwiftUI property wrappers through interactive examples. Each demo is self-contained and includes practical use cases to help developers understand when and how to use each property wrapper.

## Featured Property Wrappers

The app includes demos for the following property wrappers:

- `@State` - For simple value types that need to trigger view updates
- `@Binding` - For two-way binding between parent and child views
- `@StateObject` - For reference types that need to persist across view updates
- `@ObservedObject` - For observing changes in external objects
- `@Published` - For marking properties that should trigger view updates
- `@Environment` - For accessing environment values
- `@EnvironmentObject` - For dependency injection of observable objects
- `@AppStorage` - For persisting data in UserDefaults
- `@SceneStorage` - For persisting data specific to a scene
- `@FocusState` - For managing focus in SwiftUI views
- `@Bindable` - For creating bindable properties in SwiftUI

## Project Structure

- `Demos/` - Contains individual demo views for each property wrapper
- `Models/` - Contains data models used in the demos
- `HelperViews/` - Contains reusable view components
- `Utils/` - Contains utility functions and extensions

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Getting Started

1. Clone the repository
2. Open `PropertyWrappers.xcodeproj` in Xcode
3. Build and run the project

## Usage

Each demo is accessible through the main navigation view. Select a property wrapper from the list to see its implementation and behavior in action. Each demo includes:

- A practical example of the property wrapper in use
- Interactive elements to demonstrate the wrapper's behavior
- Explanatory comments and documentation

## Contributing

Feel free to submit issues and enhancement requests!
