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
    
    private let tts = TextToSpeech()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Image("makeasentenceplain")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: geometry.size.height * 0.02) {
                    Text("Tap on a word to start!")
                        .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.03))
                        .padding(.top, geometry.size.height * 0.02)
                        .padding(.bottom, geometry.size.height * 0.02)
                        .foregroundColor(Color.black.opacity(0.6))
                    
                    ScrollView {
                        LazyVStack(spacing: geometry.size.height * 0.025) {
                            ForEach(Array(vm.currentWordLevel.wordlist.enumerated()), id: \.element.id) { index, word in
                                let wordList = vm.currentWordLevel.wordlist
                                let viewModel = MakeAWordViewModel(wordList: wordList, currentIndex: index)
                                
                                CustomNavLinkView(
                                    destination: MakeAWordWithLetters(viewModel: viewModel)
                                        .customNavigationTitle("Place The Letters")
                                        .environmentObject(userProgress)
                                ) {
                                    WordFlashCardView(word: word) {
                                        vm.playSound(soundName: word.word)
                                    }
                                        .frame(height: geometry.size.height * 0.27)
                                        .padding(.horizontal, geometry.size.width * 0.02)
                                        .environmentObject(userProgress)
                                }
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, geometry.size.width * 0.03)
            }
        }
        .onAppear {
                //vm.playSlowSound(soundName: "TapOnAWordToStart")
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



