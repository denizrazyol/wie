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
    
    @Published var player: AVAudioPlayer?
    
    init() {

        self.searchText =  "Search by name"
        
        self.wordLevels = WordModel.wordLevels
        
        self.currentWordLevel = WordModel.wordLevels.first!
        self.currentWordModel = (WordModel.wordLevels.first?.wordlist.first)!
    }
    
    func toogleWordsList() {
        withAnimation(.easeInOut) {
            showWordsList = !showWordsList
        }
    }
    
    func showNextSet(wordLevel: WordLevel) {
        withAnimation(.easeInOut) {
            currentWordLevel = wordLevel
            currentWordModel =  wordLevel.wordlist.first!
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
}

