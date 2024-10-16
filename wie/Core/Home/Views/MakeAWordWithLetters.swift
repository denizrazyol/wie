
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
            
            VStack(spacing: geometry.size.height * 0.04) {
                
                VStack(spacing: 20) {
                    instructionView(geometry: geometry)
                        .frame(height: geometry.size.height * 0.1)
                    wordDisplayArea(in: geometry)
                    lettersArea(in: geometry)
                }
                .padding(.horizontal)
                
                
                actionButton()
                //.padding(.bottom, geometry.size.height * 0.05)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
        Text(viewModel.showRewardAnimation ? "Great Job!" : "Drag and drop the letters to form the correct word!")
            .font(.custom("ChalkboardSE-Regular", size: geometry.size.height * 0.03))
            .multilineTextAlignment(.center)
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
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.yellow.opacity(0.9))
                .frame(height: geometry.size.height * 0.4)
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
            
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
                        .padding(.top, 10)
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
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                        Text("Try Again")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15)
                    .shadow(radius: 5)
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
