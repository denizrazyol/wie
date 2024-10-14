


//
//  MakeAWordWithLetters.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 10/11/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation


struct LetterModel: Identifiable, Codable {
    let id: UUID
    var text: String
    var position: CGPoint
    var isVisible: Bool
    
}

struct MakeAWordWithLetters: View {
    
    var wordList: [WordModel]
    @State private var currentIndex: Int
    @State private var word: String
    
    @State private var currentWord = ""
    @State private var letters: [LetterModel] = []
    @State private var animateCheckmark = false
    
    @ObservedObject var userProgress = UserProgress.shared
    @State private var showRewardAnimation = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // Layout constants
    let spacing: CGFloat = 10
    let lineSpacing: CGFloat = 10
    let letterSize: CGSize = CGSize(width: 55, height: 55)
    let maxLettersPerLine: Int = 6
    let wordAreaFrame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.28, width: UIScreen.main.bounds.width, height: 300)
    
    init(wordList: [WordModel], currentIndex: Int) {
        self.wordList = wordList
        _currentIndex = State(initialValue: currentIndex)
        _word = State(initialValue: wordList[currentIndex].word)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                ZStack {
                    // Letter views
                    ForEach(letters.indices, id: \.self) { index in
                        if letters[index].isVisible {
                            LetterView(
                                letter: letters[index].text,
                                index: letters[index].id,
                                onChanged: updatePosition,
                                onEnded: updateVisibility
                            )
                            .position(positionForLetter(at: index, in: geometry.size))
                        }
                    }
                    
                    // Word area
                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: wordAreaFrame.width, height: wordAreaFrame.height)
                        .cornerRadius(20)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.minY + 50)
                    
                    // Current word display
                    Text(currentWord)
                        .font(.custom("ChalkboardSE-Regular", size: 50))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.theme.accent)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.minY + 40)
                    
                    // Success animation
                    if currentWord == word && letters.allSatisfy({ !$0.isVisible }) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundColor(Color.yellow).opacity(0.4)
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .scaleEffect(animateCheckmark ? 2 : 0.8)
                            .position(x: wordAreaFrame.midX, y: wordAreaFrame.midY + 30)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    animateCheckmark = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        animateCheckmark = false
                                    }
                                }
                            }
                    }
                    
                    // Play button
                    Button {
                        // Add action here, e.g., play sound
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.theme.iconColor)
                    }
                    .position(x: wordAreaFrame.minX + 40, y: wordAreaFrame.minY - 70)
                }
                
                // Next or Finish button logic
                Group {
                    if currentWord == word && letters.allSatisfy({ !$0.isVisible }) {
                        RewardAnimationView()
                            .onAppear {
                                if !showRewardAnimation {
                                    showRewardAnimation = true
                                    userProgress.earnStar()
                                    userProgress.addPoints(10)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        if currentIndex < wordList.count - 1 {
                                            currentIndex += 1
                                            word = wordList[currentIndex].word
                                            resetWordState()
                                            showRewardAnimation = false
                                        } else {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                    } else if !currentWord.isEmpty {
                        // Try Again button
                        Button(action: {
                            resetWordState()
                        }) {
                            Text("Try Again")
                                .font(.headline)
                                .frame(width: 200, height: 40)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        // Finish button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Finish")
                                .font(.headline)
                                .frame(width: 200, height: 40)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    initializeLetters()
                }
                .onChange(of: word) { _ in
                    checkForCompletion()
                }
            }
        }
    }
    
    // Functions to manage letters and positions
    func updatePosition(of id: UUID, with newPosition: CGPoint) {
        if let index = letters.firstIndex(where: { $0.id == id }) {
            letters[index].position = newPosition
        }
    }
    
    func updateVisibility(of id: UUID, with newPosition: CGPoint) {
        if wordAreaFrame.contains(newPosition) {
            if let index = letters.firstIndex(where: { $0.id == id }) {
                letters[index].isVisible = false
                currentWord += letters[index].text
            }
        }
    }
    
    func initializeLetters() {
        let stringLetters = word.map { String($0) }
        let shuffledLetters = stringLetters.shuffled()
        letters = []
        var x = 90
        let y = 420
        for item in shuffledLetters {
            letters.append(LetterModel(id: UUID(), text: item, position: CGPoint(x: x, y: y), isVisible: true))
            x += 76
        }
    }
    
    func resetWordState() {
        currentWord = ""
        letters.removeAll()
        initializeLetters()
    }
    
    func checkForCompletion() {
        if currentWord == word && letters.allSatisfy({ !$0.isVisible }) {
            if !showRewardAnimation {
                showRewardAnimation = true
                userProgress.earnStar()
                userProgress.addPoints(10)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if currentIndex < wordList.count - 1 {
                        currentIndex += 1
                        word = wordList[currentIndex].word
                        resetWordState()
                        showRewardAnimation = false
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    
    func positionForLetter(at index: Int, in size: CGSize) -> CGPoint {
        let lineIndex = index / maxLettersPerLine
        let columnIndex = index % maxLettersPerLine
        let lettersInLine = min(maxLettersPerLine, letters.count - lineIndex * maxLettersPerLine)
        let totalWidthCurrentLine = CGFloat(lettersInLine) * letterSize.width + CGFloat(lettersInLine - 1) * spacing
        let startX = (size.width - totalWidthCurrentLine) / 2 + letterSize.width / 2
        let x = startX + CGFloat(columnIndex) * (letterSize.width + spacing)
        let y = 50 + CGFloat(lineIndex) * (letterSize.height + lineSpacing)
        return CGPoint(x: x, y: y)
    }
}

struct MakeAWordWithLetters_Previews: PreviewProvider {
    static var previews: some View {
        MakeAWordWithLetters(wordList: [WordModel(fromString: "to")], currentIndex: 0)}
}
