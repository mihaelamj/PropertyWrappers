//
//  UnsupportedView.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 25.03.2025..
//

import SwiftUI

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
