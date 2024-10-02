//
//  GridView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 24/01/2024.
//

import SwiftUI

struct WordSelection: Identifiable {
    let id = UUID()
    let start: IndexPath
    let end: IndexPath
}

class WordSearchGame: ObservableObject {
    
    @Published var grid: [[Character]] = [[]]
    @Published var selectedIndices: Set<IndexPath> = []
    @Published var verifiedIndices: Set<IndexPath> = []
    @Published var matchedWords: [String] = []
    @Published var foundWordSelections: [WordSelection] = []
    var aimWords: [String] = []
    var selectedLetters: [(character: Character, position: IndexPath)] = []
    
    init() {}
    
    func setAimWords(_ words: [String]) {
        self.aimWords = words
        generateWordSearchGrid(rows: 13, columns: 9, words: aimWords)
        // Reset game state
        selectedIndices.removeAll()
        verifiedIndices.removeAll()
        matchedWords.removeAll()
        selectedLetters.removeAll()
        foundWordSelections.removeAll()
    }
    
    
    
    func updateSelection(from position: CGPoint, in geometry: GeometryProxy) {
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
    
    func generateWordSearchGrid(rows: Int, columns: Int, words: [String]) {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var grid = Array(repeating: Array(repeating: Character(" "), count: columns), count: rows)
        
        for word in words.shuffled() {
            var attempts = 0
            var placed = false
            while !placed && attempts < 100 {
                let horizontal = Bool.random()
                let startRow = Int.random(in: 0..<rows)
                let startCol = Int.random(in: 0..<columns)
                
                if horizontal && startCol + word.count <= columns {
                    
                    if canPlaceWord(word, in: grid, at: (startRow, startCol), horizontal: true) {
                        for (index, char) in word.enumerated() {
                            grid[startRow][startCol + index] = char
                        }
                        placed = true
                    }
                } else if !horizontal && startRow + word.count <= rows {
                    
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
    
    func clearSelection() {
        selectedIndices.removeAll()
        selectedLetters.removeAll()
        selectedIndices = verifiedIndices
    }
    
}

struct LetterCell: View {
    var letter: Character
    var isSelected: Bool
    
    var body: some View {
        Text(String(letter))
            .font(.custom("ChalkboardSE-Regular", size: 31))
            .fixedSize()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ , maxHeight: .infinity)
            .foregroundColor(.black)
            .background(isSelected ? Color.theme.iconColor.opacity(0.6) : Color.clear)
           
    }
}

struct GridView: View {
    
    @ObservedObject var game: WordSearchGame
    var onCompletion: () -> Void
    var onUpdateWord: ([String]) -> Void
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(game.grid.indices, id: \.self) { rowIndex in
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(game.grid[rowIndex].indices, id: \.self) { columnIndex in
                                LetterCell(
                                    letter: game.grid[rowIndex][columnIndex],
                                    isSelected: game.selectedIndices.contains(IndexPath(row: rowIndex, section: columnIndex)))
                                .id(rowIndex * game.grid[rowIndex].count + columnIndex)
                            }
                        }
                    }
                }
                ForEach(game.foundWordSelections) { selection in
                    wordBorder(start: selection.start, end: selection.end, in: geometry)
                }
                if let first = game.selectedLetters.first, let last = game.selectedLetters.last {
                    wordBorder(start: first.position, end: last.position, in: geometry)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        game.updateSelection(from: value.location, in: geometry)
                    }
                    .onEnded { value in
                        let word = game.getWordFromSelectedLetters().lowercased()
                        
                        if game.aimWords.contains(word) && !game.matchedWords.contains(word) {
                            game.matchedWords.append(word)
                            game.verifiedIndices.formUnion(game.selectedIndices)
                            
                            if let first = game.selectedLetters.first, let last = game.selectedLetters.last {
                                let selection = WordSelection(start: first.position, end: last.position)
                                game.foundWordSelections.append(selection)
                            }
                            
                            game.clearSelection()
                            checkCompletion()
                        } else {
                            game.clearSelection()
                        }
                    }
            )
        }
        //.padding(8)
    }
    
    func wordBorder(start: IndexPath, end: IndexPath, in geometry: GeometryProxy) -> some View {
        let startRow = start.row
        let startCol = start.section
        let endRow = end.row
        let endCol = end.section
        
        let cellWidth = geometry.size.width / CGFloat(game.grid[0].count)
        let cellHeight = geometry.size.height / CGFloat(game.grid.count)
        
        let xPosition = min(CGFloat(startCol), CGFloat(endCol)) * cellWidth
        let yPosition = min(CGFloat(startRow), CGFloat(endRow)) * cellHeight
        
        let width = (abs(CGFloat(endCol - startCol)) + 1) * cellWidth
        let height = (abs(CGFloat(endRow - startRow)) + 1) * cellHeight
        
        return RoundedRectangle(cornerRadius: 5)
            .stroke(Color.theme.iconColor, lineWidth: 3)
            .frame(width: width, height: height)
            .position(x: xPosition + width / 2, y: yPosition + height / 2)
    }
    
    func checkCompletion() {
        if game.matchedWords.count == game.aimWords.count {
            onCompletion()
        }else {
            onUpdateWord(game.matchedWords)
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordSearchGame()
        game.setAimWords(["sample", "words", "for", "preview"])
        
        return GridView(game: game, onCompletion: {
            
        }, onUpdateWord: { matchedWords in
            
        })
        
    }
}
