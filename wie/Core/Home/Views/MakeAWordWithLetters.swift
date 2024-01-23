


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
    
    @StateObject private var vm = HomeViewModel()
    @Binding var word: String
    
    @State private var currentWord = ""
    @State private var stringLetters: [String] = []
    @State private var shuffledLetters: [String] = []
    @State private var isWordCorrect: Bool?
    @State private var animateCheckmark = false
    @State private var letters: [LetterModel] = []
    
    var onNext: (() -> Void)?
    
    
    let spacing: CGFloat = 10
    let lineSpacing: CGFloat = 10
    let letterSize: CGSize = CGSize(width: 55, height: 55)
    let maxLettersPerLine: Int = 6
    let wordAreaFrame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.3, width: UIScreen.main.bounds.width, height: 300)
      
    var body: some View {
        GeometryReader { geometry in
            VStack() {
            
                ZStack() {
                    
                    ForEach(letters.indices, id: \.self) { index in
                        if letters[index].isVisible {
                            
                            LetterView(letter: letters[index].text, index: letters[index].id, onChanged: self.updatePosition, onEnded: self.updateVisibility )
                                .position(self.positionForLetter(at: index, in: geometry.size))
                  
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: wordAreaFrame.width, height: wordAreaFrame.height)
                        .cornerRadius(20)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.minY + 80)
                    
                    Text(currentWord)
                        .font(.system(size: 80))
                        .foregroundColor(Color.theme.accent)
                        .position(x: wordAreaFrame.midX, y: wordAreaFrame.minY + 60)
                    
                    
                    if currentWord == word && letters.last?.isVisible == false {
                        Image(systemName: "star.fill")
                               .resizable()
                               .foregroundColor(Color.yellow).opacity(0.4)
                               .scaledToFill()
                               .frame(width: 200, height: 200)
                               .scaleEffect(animateCheckmark ? 1.5 : 1) 
                               .position(x: wordAreaFrame.midX - 10, y: wordAreaFrame.minY - 110)
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
                    if currentWord != word && letters.last?.isVisible == false  {
                        let exist = letters.contains { $0.isVisible == true }
                        if !exist {
                            Image(systemName: "autostartstop.trianglebadge.exclamationmark" )
                                .resizable()
                                .foregroundColor(Color.secondary).opacity(0.8)
                                .font(.largeTitle)
                                .scaledToFill()
                                .scaleEffect(animateCheckmark ? 1.1 : 1)
                                .frame(width: 100, height: 100)
                                .position(x: wordAreaFrame.midX - 10, y: wordAreaFrame.minY - 110)
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
                    
                   
                }
                        
                if currentWord == word && letters.last?.isVisible == false {
                        Button {
                            self.onNext?()
                        } label: {
                            Text("Next")
                                .font(.headline)
                                .frame(width: 200, height: 40)
                        }
                        .buttonStyle(.borderedProminent )
                    
                }
                else {
                    if !currentWord.isEmpty {
                    Button {
                        currentWord =  ""
                        letters.removeAll()
                        initializeLetters()
                    } label: {
                        Text("Start Again")
                            .font(.headline)
                            .frame(width: 200, height: 40)
                    }
                    .buttonStyle(.borderedProminent )
                }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                initializeLetters()
            }
            .onChange(of: word) { _ in
                currentWord = ""
                letters.removeAll()
                initializeLetters()
            }
        }
        }
    
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
        stringLetters = word.map { String($0) }
        shuffledLetters = stringLetters.shuffled()
        
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
            let y = 80 + CGFloat(lineIndex) * (letterSize.height + lineSpacing)

             return CGPoint(x: x, y: y)
        }
    
}

struct MakeAWordWithLetters_Previews: PreviewProvider {
    static var previews: some View {
        MakeAWordWithLetters(word: .constant("to"))
    }
}
