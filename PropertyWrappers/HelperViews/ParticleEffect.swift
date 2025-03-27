//
//  ParticleEffect.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 27.03.2025..
//

import SwiftUI

// Simple Particle Effect View
struct ParticleEffect: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<10) { i in
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(.blue.opacity(0.8))
                    .offset(x: animate ? CGFloat.random(in: -20...20) : 0,
                           y: animate ? CGFloat.random(in: -20...20) : 0)
                    .animation(
                        Animation.easeOut(duration: 0.5)
                            .delay(Double(i) * 0.05),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
