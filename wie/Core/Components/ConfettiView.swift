//
//  ConfettiView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/09/2024.
//

import SwiftUI

struct ConfettiView: View {
    
    @State private var isAnimating = false
        
        var body: some View {
            GeometryReader { geometry in
                ForEach(0..<100) { _ in
                    Circle()
                        .fill(Color.random)
                        .frame(width: 10, height: 10)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: isAnimating ? geometry.size.height : 0
                        )
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
}

#Preview {
    ConfettiView()
}
