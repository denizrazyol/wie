//
//  HomeViewModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 07/11/2023.
//

import Foundation
import SwiftUI
import AVFoundation

class HomeViewModel: ObservableObject {
    
    
    
    @Published var wordLevels: [WordLevel]
    
    @Published var searchText: String = ""
    
    @Published var currentWordLevel: WordLevel
    @Published var currentWordModel: WordModel
    @Published var showWordsList : Bool = false
    @Published var foundWords: Set<Int> = []
    
    @Published var player: AVAudioPlayer?
    
    init() {

        self.searchText =  "Search by name"
        
        if let firstWordLevel = WordModel.wordLevels.first {
            
            self.wordLevels = WordModel.wordLevels
            self.currentWordLevel = firstWordLevel
            
            if let firstWordModel = firstWordLevel.wordlist.first {
                self.currentWordModel = firstWordModel
            }
            else {
                self.currentWordModel = WordModel(fromString: "Default")
            }
        } else {
            
            self.wordLevels = []
            self.currentWordLevel = WordLevel(name: "Year 1", wordlist: [])
            self.currentWordModel =  WordModel(fromString: "Deafult")
        }
    }
    
    func toogleWordsList() {
        withAnimation(.easeInOut) {
            showWordsList.toggle()
        }
    }
    
    func showNextSet(wordLevel: WordLevel) {
        withAnimation(.easeInOut) {
            currentWordLevel = wordLevel
            currentWordModel = wordLevel.wordlist.first ?? WordModel(fromString: "Default")
            showWordsList = false
        }
    }
    
    func updateWord(wordModel: WordModel) {
            currentWordModel = wordModel
        }
    
    func nextButtonPressed(word: String) -> String? {
        
        guard let currentIndex = currentWordLevel.wordlist.firstIndex(where: {$0.word == word}) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        guard currentWordLevel.wordlist.indices.contains(nextIndex) else {
            return nil
        }
        
        return currentWordLevel.wordlist[nextIndex].word
        
    }
    
    func markWordAsFound(_ id: Int) {
        foundWords.insert(id)
        if foundWords.count >= 6 {
            resetGame()
        }
    }
    
    func resetGame(){
        foundWords.removeAll()
        currentWordLevel.wordlist = currentWordLevel.wordlist.shuffled()
    }
    
    func playSound(soundName: String) {
        
      guard let soundFile = NSDataAsset(name: soundName) else {
        return
      }

      do {
          player = try AVAudioPlayer(data: soundFile.data)
          player?.play()
      } catch {
        print("Failed to load the sound: \(error)")
      }
    }
    
    func generateWordSearchGrid(rows: Int, columns: Int, words: [String]) -> [[Character]] {
            let letters = "abcdefghijklmnopqrstuvwxyz"
            var grid = Array(repeating: Array(repeating: Character(" "), count: columns), count: rows)

            for word in words {
                var placed = false
                while !placed {
                    let horizontal = Bool.random()
                    let startRow = Int.random(in: 0..<rows)
                    let startCol = Int.random(in: 0..<columns)

                    if horizontal {
                        if startCol + word.count <= columns {
                            var canPlace = true
                            for j in 0..<word.count where grid[startRow][startCol + j] != " " {
                                canPlace = false
                                break
                            }

                            if canPlace {
                                for (index, char) in word.enumerated() {
                                    grid[startRow][startCol + index] = char
                                }
                                placed = true
                            }
                        }
                    } else {
                        if startRow + word.count <= rows {
                            var canPlace = true
                            for i in 0..<word.count where grid[startRow + i][startCol] != " " {
                                canPlace = false
                                break
                            }

                            if canPlace {
                                for (index, char) in word.enumerated() {
                                    grid[startRow + index][startCol] = char
                                }
                                placed = true
                            }
                        }
                    }
                }
            }

            for i in 0..<rows {
                for j in 0..<columns {
                    if grid[i][j] == " " {
                        grid[i][j] = letters.randomElement()!
                    }
                }
            }

            return grid
        }
}

