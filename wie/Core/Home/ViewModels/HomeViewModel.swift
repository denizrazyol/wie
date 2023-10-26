//
//  HomeViewModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 07/11/2023.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var wordLevels: [WordLevel]
    
    @Published var searchText: String = ""
    
    @Published var currentWordLevel: WordLevel
    @Published var showWordsList : Bool = false
    
    init() {

        self.searchText =  "Search by name"
        
        self.wordLevels = WordModel.wordLevels
        
        self.currentWordLevel = WordModel.wordLevels.first!
    }
    
    func toogleWordsList() {
        withAnimation(.easeInOut) {
            showWordsList = !showWordsList
        }
    }
    
    func showNextSet(wordLevel: WordLevel) {
        withAnimation(.easeInOut) {
            currentWordLevel = wordLevel
            showWordsList = false
        }
    }
    

}

