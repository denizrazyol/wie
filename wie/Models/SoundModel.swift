//
//  SoundModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/01/2024.
//

import Foundation
class SoundModel:  Identifiable, Codable {
    
    let id = UUID().uuidString
    let soundName: String
    let word: WordModel
    
    init(soundName: String, word: WordModel) {
        self.soundName = soundName
        self.word = word
    }
    
    static func == (lhs: SoundModel, rhs: SoundModel) -> Bool {
        lhs.id == rhs.id
    }
  
}
