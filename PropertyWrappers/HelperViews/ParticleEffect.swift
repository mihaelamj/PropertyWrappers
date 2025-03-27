//
//  ParticleEffect.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 27.03.2025..
//

import SwiftUI

struct ParticleEffect: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<10) { index in
                Circle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 10, height: 10)
                    .offset(
                        x: isAnimating ? CGFloat.random(in: -100...100) : 0,
                        y: isAnimating ? CGFloat.random(in: -100...100) : 0
                    )
                    .opacity(isAnimating ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.0)
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// Preview for testing
struct ParticleEffect_Previews: PreviewProvider {
    static var previews: some View {
        ParticleEffect()
            .frame(width: 200, height: 200)
            .background(Color.gray.opacity(0.2))
    }
}
