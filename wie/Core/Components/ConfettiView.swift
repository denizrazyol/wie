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
            ZStack {
                ForEach(0..<100) { _ in
                    Circle()
                        .foregroundColor(Color.random)
                        .frame(width: 10, height: 10)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .transition(.scale)
                }
            }
        }
    }
}

#Preview {
    ConfettiView()
}
