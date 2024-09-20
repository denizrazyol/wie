//
//  MakeSentenceView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct ElementModel: Identifiable, Codable {
    let id: Int
    var text: String
    var position: CGPoint
    var isVisible: Bool
}

struct WhatsOnTheTrayView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showTray = false
    @State private var wordList: [WordModel] = []
    @State private var tray: [WordModel] = []
    
    @ObservedObject var userProgress = UserProgress.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack()  {
                if showTray {
                    BottomTrayView(showTray: $showTray, wordList: $wordList, tray: $tray, resetGameAction: resetGame)
                } else {
                    instructionView(geometry: geometry)
                    
                    Text("How many you can remember")
                        .font(.headline)
                        .padding(.vertical)
                    
                    Button(action: {
                        withAnimation {
                            showTray.toggle()
                        }
                    }) {
                        Text("Let's See")
                            .font(.headline)
                            .frame(width: 200, height: 40)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                loadTrayWords()
            }
            .padding(.horizontal)
        }
    }
    
    private func loadTrayWords() {
        let shuffledWordList = vm.currentWordLevel.wordlist.shuffled()
        wordList = Array(shuffledWordList.prefix(8))
        tray = Array(wordList.shuffled().prefix(6))
    }
    
    private func resetGame() {
        loadTrayWords()
    }
    
    @ViewBuilder
    private func instructionView(geometry: GeometryProxy) -> some View {
        VStack() {
            Text("Look carefully at the words on the tray!")
                .font(.headline)
                .padding(.vertical, 20)
            
            TrayContentStack(tray: $tray, geometry: geometry)
        }
    }
}

struct TrayContentStack: View {
    @Binding var tray: [WordModel]
    let geometry: GeometryProxy
    
    var body: some View {
        let count = tray.count
        
        ZStack() {
            TrayView()
            VStack(alignment: .center, spacing: 10) {
                ForEach(0..<count, id: \.self) { index in
                    if index % 2 == 0 && index + 1 < count {
                        HStack(alignment: .top, spacing: 10) {
                            CardView(word: tray[index].word, maxWidth: geometry.size.width * 0.5, status: .empty)
                                .frame(maxWidth: .infinity)
                                .padding(2)
                            CardView(word: tray[index + 1].word, maxWidth: geometry.size.width * 0.5, status: .empty)
                                .frame(maxWidth: .infinity)
                                .padding(2)
                        }
                    } else if index % 2 == 0 {
                        HStack(alignment: .top, spacing: 10) {
                            CardView(word: tray[index].word, maxWidth: geometry.size.width * 0.5, status: .empty)
                                .frame(maxWidth: .infinity)
                                .padding(2)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct BottomTrayView: View {
    @Binding var showTray: Bool
    @Binding var wordList: [WordModel]
    @Binding var tray: [WordModel]
    
    var resetGameAction: () -> Void
    
    @State private var selectedWords: Set<String> = []
    @State private var score: Int = 0
    @State private var showCongratulations = false
    @State private var hasCheckedAnswer = false
    @State private var hasAwardedReward = false
    private let maxSelection = 6
    
    @ObservedObject var userProgress = UserProgress.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if showCongratulations {
                    VStack {
                        Text("Great Job! 🎉 You've found all the words!")
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding()
                            .scaleEffect(showCongratulations ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: showCongratulations)
                        
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
                            withAnimation {
                                showCongratulations = false
                                selectedWords = []
                                score = 0
                                hasCheckedAnswer = false
                                resetGameAction()
                                showTray = false
                            }
                        }
                    }
                } else {
                    VStack {
                        Text(score > 0 ? "Score: \(score) out of 6" : "")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        wordPairsStack(geometry: geometry, newShuffle: wordList)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .disabled(showCongratulations)
                        
                        if !showCongratulations {
                            if(score < 6) {
                                Button(!hasCheckedAnswer ? "Check Your Answer" : "Let's Try Again") {
                                 
                                        withAnimation {
                                            let common = selectedWords.intersection(tray.map { $0.word })
                                            score = common.count
                                            hasCheckedAnswer = true
                                            if score == 6 {
                                                showCongratulations = true
                                                hasAwardedReward = false // Reset to allow reward
                                            }
                                        }
                                    
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                    .onTapGesture {
                        if !showCongratulations {
                            withAnimation {
                                showTray = false
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    private func wordPairsStack(geometry: GeometryProxy, newShuffle: [WordModel]) -> some View {
        VStack(alignment: .leading) {
            ForEach(Array(wordList.enumerated()), id: \.element.id) { index, element in
                if index % 2 == 0 {
                    HStack(alignment: .top, spacing: 10) {
                        cardView(word: newShuffle[index], maxWidth: geometry.size.width * 0.5 )
                            .padding(2)
                        if index + 1 < newShuffle.count {
                            cardView(word: newShuffle[index + 1], maxWidth: geometry.size.width * 0.5)
                                .padding(2)
                        }
                    }
                }
            }
        }
    }
    
    private func cardView(word: WordModel, maxWidth: CGFloat) -> some View {
        CardView(
            word: word.word,
            maxWidth: maxWidth,
            backgorundColor: selectedWords.contains(word.word) ? nil : Color.theme.accent,
            status: .empty
        )
        .frame(maxWidth: .infinity)
        .onTapGesture {
            if !showCongratulations {
                toggleSelection(of: word.word)
            }
        }
    }
    
    private func toggleSelection(of word: String) {
        if selectedWords.contains(word) {
            selectedWords.remove(word)
        } else if selectedWords.count < maxSelection {
            selectedWords.insert(word)
        }
    }
}

struct MakeSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsOnTheTrayView()
            .environmentObject(HomeViewModel())
            .ignoresSafeArea()
    }
}
