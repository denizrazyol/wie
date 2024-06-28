//
//  CommonExceptionWordsView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct CommonExceptionWordsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selection: String?
    @State private var selectedWord: String = ""
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        
        List(vm.currentWordLevel.wordlist.indices, id: \.self) { index in
            let word = vm.currentWordLevel.wordlist[index]
            ZStack {
                CustomNavLinkView(destination: MakeAWordWithLetters(word: word.word, onNext: {
                    selectedWord = vm.nextButtonPressed(word: word.word)!
                })
                    .customNavigationTitle("Place The Letters")
                ) { EmptyView() }
                    .opacity(0.0)
                WordFlashCardView(word: word)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .padding(.top, index == 0 ? 10 : 0) 
        }
        .listStyle(PlainListStyle())
        
    }
}

struct CommonExceptionWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CommonExceptionWordsView().environmentObject(HomeViewModel())
    }
}



