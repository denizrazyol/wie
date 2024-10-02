//
//  WordBasicView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 25/01/2024.
//

import SwiftUI

struct StrikethroughModifier: ViewModifier {
    var isActive: Bool
    var color: Color
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geometry in
                if isActive {
                    Rectangle()
                        .foregroundColor(color)
                        .frame(height: lineWidth)
                        .offset(y: (geometry.size.height / 2 - lineWidth / 2) + 5)
                }
            }
        )
    }
}

extension View {
    func customStrikethrough(_ isActive: Bool = true, color: Color = .black, lineWidth: CGFloat = 1) -> some View {
        self.modifier(StrikethroughModifier(isActive: isActive, color: color, lineWidth: lineWidth))
    }
}

struct WordBasicView: View {
    
    var word: String
    var index : Int
    var isFounded: Bool = false
    
    var body: some View {
        Text(word)
            .padding(.vertical, 8)
            .padding(.trailing, 6)
            .font(.custom("ChalkboardSE-Regular", size: 24))
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .customStrikethrough(isFounded, color: Color.theme.iconColor, lineWidth: 3)
            .animation(.easeInOut(duration: 0.3), value: isFounded)
    }
}

#Preview {
    WordBasicView(word: "Today", index: 1)
}
