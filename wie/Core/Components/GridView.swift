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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    init() {}
    
    func setAimWords(_ words: [String], horizontalSizeClass: UserInterfaceSizeClass) {
        self.aimWords = words
        // Revert back to original grid size
        let columns = (horizontalSizeClass == .regular ? 12 : 9)
        generateWordSearchGrid(rows: 13, columns: columns, words: aimWords)
        
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
        
        guard rowIndex >= 0 && rowIndex < grid.count && columnIndex >= 0 && columnIndex < grid[0].count else {
            return
        }
        
        let indexPath = IndexPath(row: rowIndex, section: columnIndex)
        
        // If this is the first letter being selected
        if selectedLetters.isEmpty {
            selectedIndices.insert(indexPath)
            selectedLetters.append((character: grid[rowIndex][columnIndex], position: indexPath))
            return
        }
        
        // Get the first selected position
        guard let firstPosition = selectedLetters.first?.position else { return }
        
        // Calculate direction from first selected letter to current position
        let rowDiff = indexPath.row - firstPosition.row
        let colDiff = indexPath.section - firstPosition.section
        
        // Check if selection is in a straight line (horizontal, vertical, or diagonal)
        let isHorizontal = rowDiff == 0
        let isVertical = colDiff == 0
        let isDiagonal = abs(rowDiff) == abs(colDiff)
        
        if isHorizontal || isVertical || isDiagonal {
            // Keep verified indices (found words) and add new selection
            selectedIndices = verifiedIndices
            selectedLetters.removeAll()
            
            // Add first letter back
            selectedLetters.append((character: grid[firstPosition.row][firstPosition.section], 
                                  position: firstPosition))
            selectedIndices.insert(firstPosition)
            
            // Calculate step direction
            let stepRow = rowDiff == 0 ? 0 : rowDiff / abs(rowDiff)
            let stepCol = colDiff == 0 ? 0 : colDiff / abs(colDiff)
            
            // Add all letters in the line from first to current position
            var currentRow = firstPosition.row
            var currentCol = firstPosition.section
            
            while true {
                currentRow += stepRow
                currentCol += stepCol
                
                let currentPath = IndexPath(row: currentRow, section: currentCol)
                selectedIndices.insert(currentPath)
                selectedLetters.append((character: grid[currentRow][currentCol], 
                                      position: currentPath))
                
                if currentRow == indexPath.row && currentCol == indexPath.section {
                    break
                }
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
        
        // Sort words by length (longest first)
        let sortedWords = words.sorted { $0.count > $1.count }
        
        // Define all possible directions
        let directions = [
            (0, 1),   // horizontal
            (1, 0),   // vertical
            (1, 1),   // diagonal down-right
            (1, -1),  // diagonal down-left
        ]
        
        for word in sortedWords {
            var placed = false
            let wordChars = Array(word.lowercased())
            
            // Try each direction until word is placed
            for (dRow, dCol) in directions where !placed {
                // Try each starting position
                for row in 0..<rows where !placed {
                    for col in 0..<columns {
                        // Calculate end position
                        let endRow = row + (dRow * (wordChars.count - 1))
                        let endCol = col + (dCol * (wordChars.count - 1))
                        
                        // Check if word fits within grid bounds
                        if endRow >= 0 && endRow < rows && endCol >= 0 && endCol < columns {
                            if canPlaceWordAt(word: wordChars, row: row, col: col, dRow: dRow, dCol: dCol, in: grid) {
                                placeWord(wordChars, at: row, col: col, dRow: dRow, dCol: dCol, in: &grid)
                                placed = true
                                break
                            }
                        }
                    }
                }
            }
            
            if !placed {
                print("Warning: Could not place word: \(word). Consider increasing grid size.")
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
        
        self.grid = grid
    }
    
    private func canPlaceWordAt(word: [Character], row: Int, col: Int, dRow: Int, dCol: Int, in grid: [[Character]]) -> Bool {
        let length = word.count
        
        // Check if the word fits
        for i in 0..<length {
            let newRow = row + (dRow * i)
            let newCol = col + (dCol * i)
            
            let currentCell = grid[newRow][newCol]
            if currentCell != " " && currentCell != word[i] {
                return false
            }
        }
        return true
    }
    
    private func placeWord(_ word: [Character], at row: Int, col: Int, dRow: Int, dCol: Int, in grid: inout [[Character]]) {
        for (index, char) in word.enumerated() {
            let newRow = row + (dRow * index)
            let newCol = col + (dCol * index)
            grid[newRow][newCol] = char
        }
    }
    
    func clearSelection() {
        // Keep verified indices (found words) but clear current selection
        selectedIndices = verifiedIndices
        selectedLetters.removeAll()
    }
    
    func runTests() {
        print("\n=== Starting Word Search Tests ===")
        
        // Test Case 1: Long Words
        let testCase1 = [
            "understanding",  // 13 letters
            "particularly",   // 12 letters
            "mathematics",    // 11 letters
            "information"     // 11 letters
        ]
        testWordPlacement(words: testCase1, name: "Long Words")
        
        // Test Case 2: Long Words with Common Letters
        let testCase2 = [
            "interesting",    // 11 letters
            "intelligent",    // 11 letters
            "interaction",    // 11 letters
            "interface"       // 9 letters
        ]
        testWordPlacement(words: testCase2, name: "Long Words with Common Letters")
        
        // Test Case 3: Mixed Lengths with Long Words
        let testCase3 = [
            "development",    // 11 letters
            "programming",    // 11 letters
            "code",          // 4 letters
            "application"     // 11 letters
        ]
        testWordPlacement(words: testCase3, name: "Mixed Lengths with Long Words")
        
        // Test Case 4: Long Words that Share Letters
        let testCase4 = [
            "teaching",      // 8 letters
            "reaching",      // 8 letters
            "learning",      // 8 letters
            "earning"        // 7 letters
        ]
        testWordPlacement(words: testCase4, name: "Long Words that Share Letters")
        
        print("\n=== Word Search Tests Completed ===")
    }
    
    private func testWordPlacement(words: [String], name: String) {
        print("\n--- Testing \(name) ---")
        
        // Generate grid
        generateWordSearchGrid(rows: 13, columns: 12, words: words)
        
        // Verify each word
        var allWordsFound = true
        print("Grid size: \(grid.count)x\(grid[0].count)")
        print("Words to find: \(words)")
        
        // Print grid
        print("\nGrid Contents:")
        for row in grid {
            print(row.map { String($0) }.joined(separator: " "))
        }
        
        // Find each word
        print("\nSearching for words:")
        for word in words {
            if findWord(word.lowercased()) {
                print("✓ Found: \(word)")
            } else {
                print("✗ Missing: \(word)")
                allWordsFound = false
            }
        }
        
        print("\nTest Result: \(allWordsFound ? "PASS" : "FAIL")")
    }
    
    private func findWord(_ word: String) -> Bool {
        let chars = Array(word)
        let rows = grid.count
        let cols = grid[0].count
        
        // Check horizontal, vertical, and diagonal
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
        
        for row in 0..<rows {
            for col in 0..<cols {
                for (dRow, dCol) in directions {
                    var matches = true
                    for i in 0..<chars.count {
                        let newRow = row + (dRow * i)
                        let newCol = col + (dCol * i)
                        
                        if newRow < 0 || newRow >= rows || 
                           newCol < 0 || newCol >= cols ||
                           grid[newRow][newCol].lowercased() != String(chars[i]) {
                            matches = false
                            break
                        }
                    }
                    if matches {
                        return true
                    }
                }
            }
        }
        return false
    }
}

struct LetterCell: View {
    var letter: Character
    var isSelected: Bool
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        Text(String(letter))
            .font(.custom("ChalkboardSE-Regular", size: horizontalSizeClass == .regular ? 35: 29))
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
                VStack(spacing: 0) {
                    ForEach(game.grid.indices, id: \.self) { rowIndex in
                        HStack(spacing: 0) {
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
                        handleGestureEnd()
                    }
            )
            .drawingGroup()
        }
        
    }
    
    func handleGestureEnd() {
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
        game.setAimWords(["sample", "words", "for", "preview"], horizontalSizeClass: .compact)
        game.runTests()

        return GridView(game: game, onCompletion: {
            
        }, onUpdateWord: { matchedWords in
            
        })
        
    }
}
