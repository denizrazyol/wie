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
            
            ZStack {
                
                Image("makeasentenceplain")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: 20)   {
                    if showTray {
                        BottomTrayView(showTray: $showTray, wordList: $wordList, tray: $tray, resetGameAction: resetGame)
                    } else {
                        
                            instructionView(geometry: geometry)
                                .padding(.horizontal)
                            
                        VStack(spacing: 10) {
                            
                            Text("How many you can remember")
                                .font(.custom("ChalkboardSE-Regular", size:  geometry.size.height * 0.028))
                                .foregroundColor(Color.black.opacity(0.6))
                           
                            
                            Button(action: {
                                withAnimation{
                                    showTray.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Let's See")
                                        .font(.custom("ChalkboardSE-Bold", size: 24))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 7)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    
                                    
                                }
                                .padding(.horizontal, 60)
                                .padding(.vertical,10)
                                .background(Color.theme.iconColor)
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                            .padding(.bottom, 10)
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        
                    }
                    
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    loadTrayWords()
                }
            }
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
                .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.029))
                .foregroundColor(Color.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.top, geometry.size.height * 0.02)
            
            TrayContentStack(tray: $tray, geometry: geometry)
            
        }
    }
}

struct TrayContentStack: View {
    @Binding var tray: [WordModel]
    let geometry: GeometryProxy
    
    var body: some View {
        let count = tray.count
        
        ZStack {
            TrayView()
            VStack(alignment: .center, spacing: 8) {
                ForEach(Array(stride(from: 0, to: count, by: 2)), id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        cardView(word: tray[index], maxWidth: (geometry.size.width - 48) / 2)
                        if index + 1 < count {
                            cardView(word: tray[index + 1], maxWidth: (geometry.size.width - 48) / 2)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
    }
    
    private func cardView(word: WordModel, maxWidth: CGFloat) -> some View {
        CardView(
            word: word.word,
            maxWidth: maxWidth,
            status: .empty
        )
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
    @State private var showConfetti = false
    private let maxSelection = 6
    
    @ObservedObject var userProgress = UserProgress.shared
    
    var body: some View {
        VStack {
            if showCongratulations {
                congratulatoryView()
            } else {
                VStack {
                    if score > 0 {
                        feedbackMessage()
                    } else {
                        instructionText()
                    }
                    
                    wordPairsStack()
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .disabled(showCongratulations)
                }
                .padding(.all)
                //.padding(.bottom,45)
            }
            
        }
        .onAppear {
            resetGameState()
        }
    }
    
    private func resetGameState() {
        selectedWords.removeAll()
        score = 0
        hasAwardedReward = false
    }
    
    @ViewBuilder
    private func instructionText() -> some View {
        Text("Tap on the words you remember seeing!")
            .font(.custom("ChalkboardSE-Regular", size: 22))
            .foregroundColor(Color.black.opacity(0.6))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private func feedbackMessage() -> some View {
        if score == 6 {
            Text("Amazing! You remembered all the words! 🎉")
                .font(.custom("ChalkboardSE-Regular", size: 22))
                .multilineTextAlignment(.center)
        } else if score >= 3 {
            Text("Great job! You remembered \(score) out of 6 words!")
                .font(.custom("ChalkboardSE-Regular", size: 22))
                .multilineTextAlignment(.center)
        } else {
            Text("Good try! Let's practice and try again!")
                .font(.custom("ChalkboardSE-Regular", size: 22))
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func wordPairsStack() -> some View {
        let shuffledWordList = wordList.shuffled()
        let count = shuffledWordList.count
        
        VStack(alignment: .center, spacing: 8) {
            ForEach(Array(stride(from: 0, to: count, by: 2)), id: \.self) { index in
                HStack(alignment: .top, spacing: 8) {
                    cardView(word: shuffledWordList[index], maxWidth: (UIScreen.main.bounds.width - 48) / 2)
                    if index + 1 < count {
                        cardView(word: shuffledWordList[index + 1], maxWidth: (UIScreen.main.bounds.width - 48) / 2)
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
        .onTapGesture {
            if !showCongratulations {
                toggleSelection(of: word.word)
            }
        }
    }
    
    private func toggleSelection(of word: String) {
        if selectedWords.contains(word) {
            selectedWords.remove(word)
            if score > 0 {
                score = 0
            }
        } else if selectedWords.count < maxSelection {
            selectedWords.insert(word)
            if selectedWords.count == maxSelection {
                checkAnswers()
            }
        }
    }
    
    private func checkAnswers() {
        let common = selectedWords.intersection(tray.map { $0.word })
        score = common.count
        if score == maxSelection {
            showCongratulations = true
        }
    }
    
    @ViewBuilder
    private func congratulatoryView() -> some View {
        ZStack(alignment: .center) {
            VStack() {
                Text("Great Job! 🎉 You've found all the words!")
                    .font(.custom("ChalkboardSE-Regular", size: 22))
                    .multilineTextAlignment(.center)
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
                    showConfetti = true
                    userProgress.earnStar()
                    userProgress.addPoints(10)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showCongratulations = false
                        resetGameState()
                        showConfetti = false
                        resetGameAction()
                        showTray = false
                    }
                }
            }
            
            if showConfetti {
                ConfettiView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

struct MakeSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsOnTheTrayView()
            .environmentObject(HomeViewModel())
            .ignoresSafeArea()
    }
}
