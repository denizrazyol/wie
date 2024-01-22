//
//  WrapLetterView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 21/01/2024.
//

import SwiftUI

struct WrapLetterView: View {
    
    @Binding var letters: [LetterModel]
    
    var onEnded: ((CGPoint, Int, String) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
                self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(Array(letters.enumerated()), id: \.element.id) { index, letter in
                    if letter.isVisible {
                        LetterView(letter: letter.text, index: index, onEnded: self.onEnded)
                            .padding([.horizontal, .vertical], 4)
                            .alignmentGuide(.leading, computeValue: { d in
                                if (abs(width - d.width) > g.size.width)
                                {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if letter.text == self.letters.last?.text {
                                    width = 0 //last item
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: {d in
                                let result = height
                                if letter.text == self.letters.last?.text {
                                    height = 0 // last item
                                }
                                return result
                            })
                    }
                    
                }
            }
    }
    
}

struct WrapLetterView_Previews: PreviewProvider {
    static var previews: some View {
        WrapLetterView(letters: .constant( [LetterModel(id: UUID(), text: "t", position: CGPoint(x: 10, y: 20), isVisible: true), LetterModel(id: UUID(), text: "o", position: CGPoint(x: 30, y: 40), isVisible: true)]))
    }
}
