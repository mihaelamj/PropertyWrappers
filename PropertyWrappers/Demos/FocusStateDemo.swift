//
//  FocusStateDemo.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

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
