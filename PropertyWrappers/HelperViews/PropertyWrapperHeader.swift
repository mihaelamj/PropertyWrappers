//
//  PropertyWrapperHeader.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

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
