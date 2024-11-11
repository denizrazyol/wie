//
//  WordSearchView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct WordSearchView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var gameCompleted = false
    @State private var showReward = false
    @State private var hasAwardedReward = false
    @State private var foundWords: [String] = []
    @State private var tray: [WordModel] = []
    @State private var long = false
    @State private var showConfetti = false
    @ObservedObject var userProgress = UserProgress.shared
    @StateObject private var game = WordSearchGame()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Image("makeasentenceplain")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing:0){
                    if showReward {
                        
                        withAnimation {
                            ZStack {
                                
                                ConfettiView()
                                VStack {
                                    HStack(spacing: 20) {
                                        Image("iconReward")
                                        
                                        Text("Great Job")
                                            .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.05))
                                            .foregroundColor(Color.theme.accent)
                                            .multilineTextAlignment(.center)
                                            
                                                                      
                                            
                                        
                                        Image("iconReward")
                                    }
                                    Text("You've found all the words!")
                                        .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.05))
                                        .foregroundColor(Color.theme.accent)
                                        .multilineTextAlignment(.center)
                                        
                                                            
                                    
                                }
                                
                            }
                        }
                        .transition(.scale)
                        .onAppear {
                            if !hasAwardedReward {
                                hasAwardedReward = true
                                showConfetti = true
                                userProgress.earnStar()
                                userProgress.addPoints(10)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                vm.resetGame()
                                vm.currentWordLevel.wordlist.shuffle()
                                gameCompleted = false
                                showReward = false
                                hasAwardedReward = false
                                showConfetti = false
                                tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
                                foundWords.removeAll()
                                game.setAimWords(tray.map { $0.word })
                            }
                        }
                    } else {
                        Spacer()
                        
                        GridView(game: game, onCompletion: {
                            gameCompleted = true
                            showReward = true
                        }, onUpdateWord: { matchedWords in
                            foundWords = matchedWords
                        })
                        .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.8)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .shadow(color: Color.gray.opacity(0.5), radius: 20)
                        
                        Spacer()
                        
                        VStack(spacing: 10) {
                            HStack(spacing: long ? 8 : 20) {
                                ForEach(tray.indices.prefix(3), id: \.self) { number in
                                    WordBasicView(word: tray[number].word, index: tray[number].id, isFounded: foundWords.contains(tray[number].word))
                                    
                                }
                            }
                            HStack(spacing: long ? 8 : 20) {
                                ForEach(tray.indices.dropFirst(3).prefix(3), id: \.self) { number in
                                    WordBasicView(word: tray[number].word, index: tray[number].id, isFounded: foundWords.contains(tray[number].word))
                                    
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.92)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent))
                        
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    if tray.isEmpty {
                        tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
                        game.setAimWords(tray.map { $0.word })
                        long = vm.currentWordLevel.name == "Year 5 & Year 6" ? true : false
                    }
                }
                if showConfetti {
                    ConfettiView()
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView().environmentObject(HomeViewModel())
        
    }
}
