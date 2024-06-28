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
    var index : UUID
    
    var onChanged: ((UUID, CGPoint) -> Void)?
    var onEnded: ((UUID, CGPoint) -> Void)?
    
    var body: some View {
        Text(letter)
            .font(.largeTitle)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.iconColor).frame(width: 55, height: 55))
            .foregroundColor(.white)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        self.dragAmount = CGSize(width:
                                                    value.translation.width,height:
                                                    value.translation.height)
                        
                        self.onChanged?(self.index, value.location)
                    }
                    .onEnded { value in
                      
                        self.onEnded?(self.index, value.location)
                        self.dragAmount = .zero
                    })
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView(letter: "t", index: UUID())
    }
}
