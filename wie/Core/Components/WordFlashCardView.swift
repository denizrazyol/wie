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
        
        Text(word.word)
            .font(.custom("ChalkboardSE-Regular", size: 30))
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.theme.secondaryText.opacity(0.5), radius: 5, x: 0, y: 5)
        
    }
}

struct WordFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        WordFlashCardView(word: WordModel(fromString: "1, New Word"))
        
        
    }
}
