
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

    let maxLettersPerLine: Int = 6
    let letterSize: CGSize = CGSize(width: 55, height: 55)
    let spacing: CGFloat = 10
    let lineSpacing: CGFloat = 10

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
                                 height: 100)

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
            VStack(spacing: 20) {
                wordDisplayArea()
                lettersArea(in: geometry)
                actionButton()
            }
            .padding()
            .onChange(of: viewModel.currentWord) { _ in
                viewModel.checkWordMatch()
            }
            .onAppear {
                viewModel.resetWordState()
            }
        }
    }

    func wordDisplayArea() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow.opacity(0.3))
                .frame(height: 100)

            Text(viewModel.currentWord)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.theme.accent)
                .padding()

            if viewModel.showRewardAnimation {
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(Color.yellow.opacity(0.4))
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .scaleEffect(viewModel.animateCheckmark ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatCount(3, autoreverses: true),
                        value: viewModel.animateCheckmark
                    )
                    .onAppear {
                        viewModel.animateCheckmark = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            viewModel.animateCheckmark = false
                            userProgress.earnStar()
                            userProgress.addPoints(10)
                            viewModel.advanceWord()
                        }
                    }
            }
        }
    }

    func lettersArea(in geometry: GeometryProxy) -> some View {
        let letters = viewModel.letters.filter { $0.isVisible }
        let lines = letters.chunked(into: viewModel.maxLettersPerLine)

        return VStack(spacing: viewModel.lineSpacing) {
            ForEach(0..<lines.count, id: \.self) { lineIndex in
                HStack(spacing: viewModel.spacing) {
                    ForEach(lines[lineIndex]) { letter in
                        LetterView(
                            letter: letter.text,
                            index: letter.id,
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
    }

    func actionButton() -> some View {
        Group {
            if viewModel.showRewardAnimation {
                EmptyView()
            } else if !viewModel.isCompleted {
                Button(action: {
                    viewModel.resetWordState()
                }) {
                    Text("Try Again")
                        .font(.headline)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)
            } else {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Finish")
                        .font(.headline)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)
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
        // Use your word list from WordModel
        let wordList = WordModel.year1WordsList
        let viewModel = MakeAWordViewModel(wordList: wordList, currentIndex: 0)
        return MakeAWordWithLetters(viewModel: viewModel)
            .environmentObject(UserProgress.shared)
    }
}
