//
//  LetterView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 21/01/2024.
//

import SwiftUI

struct LetterView: View {

    @State private var dragAmount = CGSize.zero

    var letter: String
    var index: UUID
    var maxWidth: CGFloat

    var onChanged: ((UUID, CGPoint) -> Void)?
    var onEnded: ((UUID, CGPoint) -> Void)?

    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: maxWidth * 0.2)
                    .fill(Color.theme.accent)

                Text(letter)
                    .font(.custom("ChalkboardSE-Regular", size: max(maxWidth * 0.6, 24)))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: maxWidth, height: maxWidth)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        self.dragAmount = value.translation
                        self.onChanged?(self.index, value.location)
                    }
                    .onEnded { value in
                        self.onEnded?(self.index, value.location)
                        self.dragAmount = .zero
                    }
            )
        }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView(letter: "t", index: UUID(),  maxWidth: 50)
    }
}
