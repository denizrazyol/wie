


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
    
    @State private var word: WordModel
    
    @State private var currentWord = ""
    @State private var stringLetters: [String]
    @State private var shuffledLetters: [String] = []
    @State private var isWordCorrect: Bool?
    @State private var animateCheckmark = false
    @State private var letters: [LetterModel] = []
    
    init(word: WordModel) {
            self.word = word
            self.stringLetters = word.word.map { String($0) }
            self._shuffledLetters = State(initialValue: stringLetters.shuffled())
    }
    
    let spacing: CGFloat = 8
    let lineSpacing: CGFloat = 20
    let letterSize: CGSize = CGSize(width: 60, height: 60)
    let maxLettersPerLine: Int = 4
    let wordAreaFrame = CGRect(x: 20, y: 10, width: 350, height: 300)
      
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                ZStack() {
                    
                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: wordAreaFrame.width, height: wordAreaFrame.height)
                        .cornerRadius(20)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.midY)
                    
                    Text(currentWord)
                        .font(.system(size: 80))
                        .foregroundColor(Color.theme.accent)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.midY)
                    
                    if currentWord == word.word && letters.last?.isVisible == false {
                        Image(systemName: "star.fill")
                               .resizable()
                               .foregroundColor(Color.yellow)
                               .scaledToFill()
                               .frame(width: 60, height: 60)
                               .scaleEffect(animateCheckmark ? 1.5 : 1) // Animated scale effect
                               .position(x: wordAreaFrame.maxX - 60, y: wordAreaFrame.minY + 30) // Position at top-right corner
                               .onAppear {
                                   withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                       animateCheckmark = true
                                   }
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust time as needed
                                       withAnimation {
                                           animateCheckmark = false
                                       }
                                   }
                               }
                               .padding()
                   
                    }
                    if currentWord != word.word && letters.last?.isVisible == false  {
                        let exist = letters.contains { $0.isVisible == true }
                        if !exist {
                            Image(systemName: "autostartstop.trianglebadge.exclamationmark" )
                                .foregroundColor(Color.secondary)
                                .font(.largeTitle)
                                .scaleEffect(animateCheckmark ? 1.1 : 1)
                                .position(x: wordAreaFrame.maxX - 50, y: wordAreaFrame.minY + 20)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                        animateCheckmark = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust time as needed
                                        withAnimation {
                                            animateCheckmark = false
                                        }
                                    }
                                }
                                .onTapGesture {
                                    currentWord =  ""
                                    letters.removeAll()
                                    initializeLetters()
                                }
                                .padding()
                        }
                    }
                    
                    ForEach(letters.indices, id: \.self) { index in
                        if letters[index].isVisible {
                            Text(letters[index].text)
                                .font(.largeTitle)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent).frame(width: letterSize.width * 1))
                                .foregroundColor(.white)
                                .frame(width: letterSize.width, height: letterSize.height)
                                .position(self.positionForLetter(at: index, in: geometry.size))
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            updatePosition(of: letters[index].id, with: value.location)
                                        }
                                        .onEnded { value in
                                            if wordAreaFrame.contains(value.location) {
                                                updateVisibility(of: letters[index].id, with: false)
                                                currentWord += letters[index].text
                                            }
                                        })
                        }
                    }
                }
                
                if currentWord !=  "" {
                    Button {
                        currentWord =  ""
                        letters.removeAll()
                        initializeLetters()
                    } label: {
                        Text("Start Again")
                            .font(.headline)
                            .frame(width: 150, height: 35)
                    }
                    .buttonStyle(.borderedProminent )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                initializeLetters()
            }
        }
        }
    
    func updatePosition(of id: UUID, with newPosition: CGPoint) {
        if let index = letters.firstIndex(where: { $0.id == id }) {
            letters[index].position = newPosition
        }
    }
    
    func updateVisibility(of id: UUID, with newState: Bool) {
        if let index = letters.firstIndex(where: { $0.id == id }) {
            letters[index].isVisible = newState
        }
    }
    
    func initializeLetters() {
        var x = 90
        let y = 420
        for item in shuffledLetters {
            letters.append(LetterModel(id: UUID(), text: item, position: CGPoint(x: x, y: y), isVisible: true))
            x += 76
        }
    }
    

    
    func positionForLetter(at index: Int, in size: CGSize) -> CGPoint {
            let lineIndex = index / maxLettersPerLine // Determine which line the letter is on
            let columnIndex = index % maxLettersPerLine // Determine column in the line

        
            let lettersInLine = min(maxLettersPerLine, letters.count - lineIndex * maxLettersPerLine)

      
            let totalWidthCurrentLine = CGFloat(lettersInLine) * letterSize.width + CGFloat(lettersInLine - 1) * spacing

        
            let startX = (size.width - totalWidthCurrentLine) / 2 + letterSize.width / 2

            let x = startX + CGFloat(columnIndex) * (letterSize.width + spacing)
            let y = size.height / 2 + CGFloat(lineIndex) * (letterSize.height + lineSpacing)

             return CGPoint(x: x, y: y)
        }
    
}

struct MakeAWordWithLetters_Previews: PreviewProvider {
    static var previews: some View {
        MakeAWordWithLetters(word: WordModel(fromString: "to"))
    }
}



