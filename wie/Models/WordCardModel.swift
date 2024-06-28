//
//  WordCardModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 01/05/2024.
//

import Foundation

class WordCardModel: Identifiable, Equatable {
    
    let id = UUID().uuidString
    let word: WordModel
    let status: Status
    
    init(word: WordModel, status: Status) {
        self.word = word
        self.status = status
    }
    
    static func == (lhs: WordCardModel, rhs: WordCardModel) -> Bool {
        lhs.id == rhs.id
    }
}
