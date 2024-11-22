//
//  SoundModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/01/2024.
//

import Foundation

class SoundModel: Identifiable, Codable {
    var id: String
    var soundName: String
    var word: WordModel

    init(id: String = UUID().uuidString, soundName: String, word: WordModel) {
        self.id = id
        self.soundName = soundName
        self.word = word
    }

    // No need to implement `==` since we're conforming to `Identifiable` and can compare `id`s directly.
}

