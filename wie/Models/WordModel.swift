//
//  WordModel.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 09/11/2023.
//

import Foundation

class WordModel: Identifiable {
    var id: Int
    var word: String
    
    required init(fromString string: String) {
        
        let components = string.split(separator: ",")
            
        if components.count == 2 {
            self.id = Int(components[0].trimmingCharacters(in: .whitespacesAndNewlines))!
            self.word = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else{
            self.id =  10
            self.word = ""
        }
    }
    
    
    static var year1WordsList: [WordModel] {
        
        var  wordDataStrings = StringsFileLoader.loadWords(fileName: "year1CommonExceptionWords")
        
        wordDataStrings = wordDataStrings.sorted{ $0.id < $1.id }
        
        return wordDataStrings
    }
    
    static var year2WordsList: [WordModel] {
        
        var  wordDataStrings = StringsFileLoader.loadWords(fileName: "year2CommonExceptionWords")
        
        wordDataStrings = wordDataStrings.sorted{ $0.id < $1.id }
        
        return wordDataStrings
    }
   
    static var wordLevels: [WordLevel] {
        return [
            WordLevel(name: "Year 1", wordlist: year1WordsList),
            WordLevel(name: "Year 2", wordlist: year2WordsList),
            WordLevel(name: "Year 3", wordlist: year1WordsList),
            WordLevel(name: "Year 4", wordlist: year2WordsList),
        ]
    }
}

class StringsFileLoader {
    static func loadWords(fileName: String) -> [WordModel] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "strings"),
                     let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
                   fatalError("Missing or invalid file: \(fileName).strings")
               }
        
        let trimmedDictionary = dictionary.filter { !$0.value.isEmpty }
               
        return trimmedDictionary.compactMap { WordModel(fromString: $0.value) }
    }
}
