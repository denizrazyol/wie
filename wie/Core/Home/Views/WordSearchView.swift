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
    @ObservedObject var userProgress = UserProgress.shared
    @StateObject private var game = WordSearchGame()
    
    var body: some View {
        
        VStack(){
            if showReward {
                
                VStack {
                    Text("Great Job! 🎉 You've found all the words!")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .scaleEffect(gameCompleted ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: gameCompleted)
                    
                    RewardAnimationView()
                        .padding()
                }
                .transition(.scale)
                .onAppear {
                    if !hasAwardedReward {
                        hasAwardedReward = true
                        userProgress.earnStar()
                        userProgress.addPoints(10)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        vm.resetGame()
                        vm.currentWordLevel.wordlist.shuffle()
                        gameCompleted = false
                        showReward = false
                        hasAwardedReward = false
                        tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
                        foundWords.removeAll()
                        game.setAimWords(tray.map { $0.word })
                    }
                }
            } else {
                
                GridView(game: game, onCompletion: {
                    gameCompleted = true
                    showReward = true
                }, onUpdateWord: { matchedWords in
                    foundWords = matchedWords
                })
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                .shadow(color: Color.gray.opacity(0.5), radius: 20)
                .padding(.bottom,10)
                
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        
                        ForEach(tray.indices.prefix(3), id: \.self) { number in
                            WordBasicView(word: tray[number].word, index: tray[number].id, isFounded: foundWords.contains(tray[number].word))
                        }
                        
                    }
                    HStack(alignment: .top) {
                        
                        ForEach(tray.indices.dropFirst(3).prefix(3), id: \.self) { number in
                            WordBasicView(word: tray[number].word, index: tray[number].id, isFounded: foundWords.contains(tray[number].word))
                            
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent))
            }
        }
        .padding()
        .onAppear {
            if tray.isEmpty {
                tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
                game.setAimWords(tray.map { $0.word })
            }
        }
    }
    
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView().environmentObject(HomeViewModel())
        
    }
}
