//
//  CommonExceptionWordsView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct CommonExceptionWordsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject var userProgress: UserProgress
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.02) {
                Text("Tap on a word to start!")
                    .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.03))
                    .padding(.vertical, geometry.size.height * 0.02)
                
                ScrollView {
                    LazyVStack(spacing: geometry.size.height * 0.02) {
                        ForEach(Array(vm.currentWordLevel.wordlist.enumerated()), id: \.element.id) { index, word in
                            let wordList = vm.currentWordLevel.wordlist
                            let viewModel = MakeAWordViewModel(wordList: wordList, currentIndex: index)
                            
                            CustomNavLinkView(
                                destination: MakeAWordWithLetters(viewModel: viewModel)
                                    .customNavigationTitle("Place The Letters")
                                    .environmentObject(userProgress)
                            ) {
                                WordFlashCardView(word: word)
                                    .frame(height: geometry.size.height * 0.2)
                                    .padding(.horizontal, geometry.size.width * 0.02)
                            }
                        }
                    }
                }
                .padding(.bottom, geometry.size.height * 0.03)
            }
            .padding(.horizontal, geometry.size.width * 0.03)
        }
    }
}

struct CommonExceptionWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CommonExceptionWordsView()
            .environmentObject(HomeViewModel())
            .environmentObject(UserProgress.shared)
    }
}



