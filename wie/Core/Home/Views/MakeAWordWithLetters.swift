
//
//  MakeAWordWithLetters.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 10/11/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

class MakeAWordViewModel: ObservableObject {
    @Published var wordList: [WordModel]
    @Published var currentIndex: Int
    @Published var currentWord: String = ""
    @Published var targetWord: String
    @Published var letters: [LetterModel] = []
    @Published var animateCheckmark = false
    @Published var showRewardAnimation = false
    @Published var isCompleted = false
    
    
    init(wordList: [WordModel], currentIndex: Int) {
        self.wordList = wordList
        self.currentIndex = currentIndex
        self.targetWord = wordList[currentIndex].word
        initializeLetters()
    }
    
    
    func initializeLetters() {
        let stringLetters = targetWord.map { String($0) }
        let shuffledLetters = stringLetters.shuffled()
        letters = shuffledLetters.map { LetterModel(id: UUID(), text: $0, isVisible: true, position: .zero) }
    }
    
    func resetWordState() {
        currentWord = ""
        initializeLetters()
    }
    
    func advanceWord() {
        if currentIndex < wordList.count - 1 {
            currentIndex += 1
            targetWord = wordList[currentIndex].word
            resetWordState()
            showRewardAnimation = false
        } else {
            isCompleted = true
        }
    }
    
    func updateLetterPosition(id: UUID, to position: CGPoint) {
        if let index = letters.firstIndex(where: { $0.id == id }) {
            letters[index].position = position
        }
    }
    
    func updateLetterVisibility(id: UUID, at position: CGPoint, in geometry: GeometryProxy) {
        let targetFrame = CGRect(x: geometry.frame(in: .global).minX,
                                 y: geometry.frame(in: .global).minY,
                                 width: geometry.size.width,
                                 height: geometry.size.height * 0.6)
        
        if targetFrame.contains(position) {
            if let index = letters.firstIndex(where: { $0.id == id }) {
                letters[index].isVisible = false
                currentWord += letters[index].text
            }
        }
    }
    
    func checkWordMatch() {
        if currentWord == targetWord && letters.allSatisfy({ !$0.isVisible }) {
            showRewardAnimation = true
        }
    }
}

struct LetterModel: Identifiable, Codable {
    let id: UUID
    var text: String
    var isVisible: Bool
    var position: CGPoint
}

struct MakeAWordWithLetters: View {
    @ObservedObject var viewModel: MakeAWordViewModel
    @EnvironmentObject var userProgress: UserProgress
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Image("makeasentence")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack() {
                    
                    instructionView(geometry: geometry)
                        .frame(height: geometry.size.height * 0.1)
                    
                    Spacer(minLength: geometry.size.height * 0.08)
                    
                    wordDisplayArea(in: geometry)
                    
                    lettersArea(in: geometry)
                    
                    Spacer()
                    
                    if !viewModel.showRewardAnimation {
                        actionButton()
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, geometry.size.height * 0.12)
                .padding(.bottom, geometry.size.height * 0.1)
                
                if viewModel.showRewardAnimation {
                    ConfettiView()
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation {
                                    userProgress.earnStar()
                                    userProgress.addPoints(10)
                                    let currentWordID = viewModel.wordList[viewModel.currentIndex].uuid
                                    userProgress.incrementPlayCount(for: currentWordID)
                                    viewModel.advanceWord()
                                }
                            }
                        }
                }
            }
            .onChange(of: viewModel.currentWord) { _ in
                viewModel.checkWordMatch()
            }
            .onAppear {
                viewModel.resetWordState()
            }
            
        }
    }
    
    @ViewBuilder
    func instructionView(geometry: GeometryProxy) -> some View {
        if viewModel.showRewardAnimation {
            
            Text("🎉 Great Job 🎉")
                .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.04))
                .foregroundColor(Color.black.opacity(0.6))
                .multilineTextAlignment(.center)
            
        } else {
            Text("Drag and drop the letters to form the correct word!")
                .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.03))
                .foregroundColor(Color.black.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }
    
    func wordDisplayArea(in geometry: GeometryProxy) -> some View {
        let horizontalPadding: CGFloat = 10
        let maxBoxWidth: CGFloat = 60
        let spacing: CGFloat = 5
        let availableWidth = geometry.size.width - 2 * horizontalPadding - CGFloat(viewModel.targetWord.count - 1) * spacing
        let boxWidth = min(maxBoxWidth, availableWidth / CGFloat(viewModel.targetWord.count))
        let boxHeight: CGFloat = boxWidth + 5
        let underlineHeight: CGFloat = 2
        
        return ZStack(alignment: .center) {
            
            VStack {
                HStack(spacing: 3) {
                    ForEach(0..<viewModel.targetWord.count, id: \.self) { index in
                        Text(viewModel.currentWord.count > index ? String(viewModel.currentWord[viewModel.currentWord.index(viewModel.currentWord.startIndex, offsetBy: index)]) : "")
                            .font(.custom("ChalkboardSE-Regular", size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color.theme.accent)
                            .frame(width: boxWidth, height: boxHeight)
                            .overlay(
                                Rectangle()
                                    .fill(Color.theme.secondaryText)
                                    .frame(height: underlineHeight)
                                    .padding(.top, boxHeight - underlineHeight)
                                , alignment: .top
                            )
                    }
                }
                
                if viewModel.showRewardAnimation {
                    
                    Text(viewModel.targetWord)
                        .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.09))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.accent)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            viewModel.animateCheckmark = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                viewModel.animateCheckmark = false
                                userProgress.earnStar()
                                userProgress.addPoints(10)
                                viewModel.advanceWord()
                            }
                        }
                }
            }
        }
    }
    
    
    
    func lettersArea(in geometry: GeometryProxy) -> some View {
        let letters = viewModel.letters.filter { $0.isVisible }
        let horizontalPadding: CGFloat = 16
        let spacing: CGFloat = 10
        let maxLetterWidth: CGFloat = 60
        let availableWidth = geometry.size.width - 2 * horizontalPadding + spacing
        let maxLettersPerLine = min(letters.count, Int(availableWidth / (maxLetterWidth + spacing)))
        let totalSpacing = CGFloat(maxLettersPerLine - 1) * spacing
        let totalWidth = geometry.size.width - 2 * horizontalPadding - totalSpacing
        let letterWidth = min(maxLetterWidth, totalWidth / CGFloat(maxLettersPerLine))
        let lines = letters.chunked(into: maxLettersPerLine)
        
        return VStack() {
            ForEach(0..<lines.count, id: \.self) { lineIndex in
                HStack(spacing: spacing) {
                    ForEach(lines[lineIndex]) { letter in
                        LetterView(
                            letter: letter.text,
                            index: letter.id,
                            maxWidth: letterWidth,
                            onChanged: { id, position in
                                viewModel.updateLetterPosition(id: id, to: position)
                            },
                            onEnded: { id, position in
                                viewModel.updateLetterVisibility(id: id, at: position, in: geometry)
                                viewModel.checkWordMatch()
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 10)
    }
    
    
    func actionButton() -> some View {
        Group {
            if viewModel.showRewardAnimation {
                EmptyView()
            } else {
                Button(action: {
                    withAnimation {
                        viewModel.resetWordState()
                    }
                }) {
                    HStack {
                        Text("Try Again")
                            .font(.custom("ChalkboardSE-Bold", size: 24))
                            .foregroundColor(.white)
                            .padding(.bottom, 7)
                        
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                    }
                    .padding(.horizontal, 60)
                    .padding(.vertical,10)
                    .background(Color.theme.iconColor)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var index = 0
        while index < count {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
            index += size
        }
        return chunks
    }
}

struct MakeAWordWithLetters_Previews: PreviewProvider {
    static var previews: some View {
        let wordList = WordModel.year5And6WordsList
        let viewModel = MakeAWordViewModel(wordList: wordList, currentIndex: 0)
        return MakeAWordWithLetters(viewModel: viewModel)
            .environmentObject(UserProgress.shared)
    }
}
