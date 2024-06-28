//
//  GridView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 24/01/2024.
//

import SwiftUI


struct WordSearchGame {
    
    var grid: [[Character]] = [[]]
    var selectedIndices: Set<IndexPath> = []
    var verifiedIndices: Set<IndexPath> = []
    var aimWords: [String]
    
    var selectedLetters: [(character: Character, position: IndexPath)] = []
    var matchedWords: [String] = []
    
    var selectedCharactersAndPositions: [(Character, Int)] = []
    
    init(aimWords: [String]) {
        
        self.aimWords = aimWords
        generateWordSearchGrid(rows: 13, columns: 9, words: aimWords)
    }
    
    
    mutating func updateSelection(from position: CGPoint, in geometry: GeometryProxy) {
        let rowHeight = geometry.size.height / CGFloat(grid.count)
        let columnWidth = geometry.size.width / CGFloat(grid[0].count)
        
        let rowIndex = Int(position.y / rowHeight)
        let columnIndex = Int(position.x / columnWidth)
        
        if rowIndex >= 0 && rowIndex < grid.count && columnIndex >= 0 && columnIndex < grid[0].count {
            let indexPath = IndexPath(row: rowIndex, section: columnIndex)
            if !selectedIndices.contains(indexPath) {
                selectedIndices.insert(indexPath)
                selectedLetters.append((character: grid[rowIndex][columnIndex], position: indexPath))
            }
        }
    }
    
    func getWordFromSelectedLetters() -> String {
         var word = ""
         for selected in selectedLetters {
             word.append(selected.character)
         }
         return word
     }
    
    mutating func generateWordSearchGrid(rows: Int, columns: Int, words: [String]) {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var grid = Array(repeating: Array(repeating: Character(" "), count: columns), count: rows)
        
        for word in words.shuffled() {  // Shuffle words to randomize placement
            var attempts = 0
            var placed = false
            while !placed && attempts < 100 {  // Limit attempts to prevent infinite loops
                let horizontal = Bool.random()
                let startRow = Int.random(in: 0..<rows)
                let startCol = Int.random(in: 0..<columns)
                
                if horizontal && startCol + word.count <= columns {
                    // Try to place horizontally
                    if canPlaceWord(word, in: grid, at: (startRow, startCol), horizontal: true) {
                        for (index, char) in word.enumerated() {
                            grid[startRow][startCol + index] = char
                        }
                        placed = true
                    }
                } else if !horizontal && startRow + word.count <= rows {
                    // Try to place vertically
                    if canPlaceWord(word, in: grid, at: (startRow, startCol), horizontal: false) {
                        for (index, char) in word.enumerated() {
                            grid[startRow + index][startCol] = char
                        }
                        placed = true
                    }
                }
                attempts += 1
            }
            if !placed {
                //print("Failed to place word: \(word)")
            }
        }
        
        // Fill remaining spaces with random letters
        for i in 0..<rows {
            for j in 0..<columns {
                if grid[i][j] == " " {
                    grid[i][j] = letters.randomElement()!
                }
            }
        }
        
        self.grid =  grid
    }
    
    private func canPlaceWord(_ word: String, in grid: [[Character]], at position: (Int, Int), horizontal: Bool) -> Bool {
        let (row, col) = position
        if horizontal {
            for j in 0..<word.count {
                if grid[row][col + j] != " " { return false }
            }
        } else {
            for i in 0..<word.count {
                if grid[row + i][col] != " " { return false }
            }
        }
        return true
    }
    
  
    
}

struct LetterCell: View {
    var letter: Character
    var isSelected: Bool
    
    var body: some View {
        Text(String(letter))
            .frame(maxWidth: 45, maxHeight: 45)
            .foregroundColor(.black)
            .background(isSelected ? Color.theme.iconColor.opacity(0.6) : Color.clear)
            .font(.title)
    }
}

struct GridView: View {
    
    var aimWords: [String] = []
    var onCompletion: () -> Void
    
    @State private var isDragging = false
    @State private var game: WordSearchGame
    
    init(wordModelList: [WordModel], onCompletion: @escaping () -> Void) {
            self.aimWords = wordModelList.map { $0.word }
            _game = State(initialValue: WordSearchGame(aimWords: aimWords))
            self.onCompletion = onCompletion
    }

    let columns: Int = 9
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<game.grid.count, id: \.self) { rowIndex in
                    HStack(spacing: 0) {
                        ForEach(0..<game.grid[rowIndex].count, id: \.self) { columnIndex in
                            let cellID = "\(rowIndex)-\(columnIndex)"
                            LetterCell(letter: game.grid[rowIndex][columnIndex],
                                       isSelected: game.selectedIndices.contains(IndexPath(row: rowIndex, section: columnIndex)))
                            .id(cellID)
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        withAnimation {
                            game.updateSelection(from: value.location, in: geometry)
                        }
                    }
                    .onEnded { value in
                        isDragging = false
                        let word = game.getWordFromSelectedLetters()
                        if game.aimWords.firstIndex(where: {$0.contains(word)}) != nil{
                            if(word.count > 1){
                                game.matchedWords.append(word)
                                game.verifiedIndices = game.selectedIndices
                                game.selectedLetters.removeAll()
                                checkCompletion()
                            }
                            else{
                                game.selectedIndices.removeAll()
                                game.selectedLetters.removeAll()
                                game.selectedIndices = game.verifiedIndices
                                
                            }
                            
                        }
                        else{
                            game.selectedIndices.removeAll()
                            game.selectedLetters.removeAll()
                            game.selectedIndices = game.verifiedIndices
                            
                        }
                        
                    }
            )
        }
        .padding(8)
    }
    
    func checkCompletion() {
            if game.matchedWords.count == game.aimWords.count {
                onCompletion() 
            }
        }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(wordModelList: [WordModel(fromString: "Word")]) {
            
        }
    }
}
