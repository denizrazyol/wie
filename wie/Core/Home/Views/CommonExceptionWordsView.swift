//
//  CommonExceptionWordsView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct CommonExceptionWordsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]
       
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Tap on a word to start!")
                            .font(.custom("ChalkboardSE-Regular", size: 22))
                            .padding(.top,8)
           
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(vm.currentWordLevel.wordlist.indices, id: \.self) { index in
                        let word = vm.currentWordLevel.wordlist[index]
                        
                        CustomNavLinkView(
                            destination: MakeAWordWithLetters(wordList: vm.currentWordLevel.wordlist, currentIndex: index)
                                
                                .customNavigationTitle("Place The Letters")
                        ) {
                            WordFlashCardView(word: word)
                               
                        }
                    }
                }
                .padding()
            }
           
        }
        
    }
}

struct CommonExceptionWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CommonExceptionWordsView().environmentObject(HomeViewModel())
    }
}



