//
//  WordFlashCardView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 08/11/2023.
//

import SwiftUI

struct WordFlashCardView: View {
    
    let word: WordModel
    
    var body: some View {
       Rectangle()
            .fill(Color.theme.accent)
            .frame(height: 150)
            .cornerRadius(25)
            .overlay(
                    Text(word.word)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
            )
    }
}

struct WordFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
     
        WordFlashCardView(word: WordModel(fromString: "1, New Word"))
              
        
    }
}
