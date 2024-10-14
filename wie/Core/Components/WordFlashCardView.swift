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
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 3)
            
            VStack {
                Text(word.word)
                    .font(.custom("ChalkboardSE-Regular", size: 30))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.all,16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) 
        }
    }
}

struct WordFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        WordFlashCardView(word: WordModel(fromString: "1, New Word"))
        
        
    }
}
