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
    var index : Int
    
    var onEnded: ((CGPoint, Int, String) -> Void)?
    
    var body: some View {
        Text(letter)
            .font(.largeTitle)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent).frame(width: 60))
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        self.dragAmount = CGSize(width:
                                                    value.translation.width,height:
                                                    value.translation.height)
                    }
                    .onEnded { value in
                      
                        self.onEnded?(value.location, self.index, self.letter)
                        self.dragAmount = .zero
                    })
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView(letter: "t", index: 1)
    }
}
