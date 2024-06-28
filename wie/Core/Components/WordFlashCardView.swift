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
            .fill(Color.white)
            .frame(height: 170)
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.4), radius: 20)
            .overlay(
                    Text(word.word)
                        .font(.title)
                        .foregroundColor(Color.black)
            )
          
    }
}

struct WordFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
     
        WordFlashCardView(word: WordModel(fromString: "1, New Word"))
              
        
    }
}
