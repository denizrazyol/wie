//
//  WordGame.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 15/01/2024.
//

import SwiftUI

struct WordGame: View {
    
    @State private var tray: [String] = ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"]
    
    @State private var activeWords: [String] = ["Item 0", "Item 1", "Item 2", "Item 3"]
    @State private var buttonFrames = [CGRect](repeating: .zero, count: 4)
    
    let allowedWords: [String] = ["Item 0", "Item 1"]
    
    let wordAreaFrame = CGRect(x: 0, y: 190, width: 470, height: 300)
    
    var body: some View {
        VStack(spacing: 20) {
            
            ZStack {
                
                
                VStack(spacing: 50){
                    LabelledDividerView(label: "Put here")
                    DividerView()
                    DividerView()
                    DividerView()
                }
                .frame(width: wordAreaFrame.width, height: wordAreaFrame.height)
                .position(x: wordAreaFrame.midX, y: wordAreaFrame.midY)
                
                HStack{
                    ForEach(0..<4){ number in
                        WordView(word: self.activeWords[number], index: number)
                            .allowsHitTesting(false)
                            .overlay(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            self.buttonFrames[number] = geo.frame(in: .global)
                                        }
                                })
                    }
                }

            }
            
            
            
            HStack(){
                ForEach(0..<5){ number in
                    WordView(word: self.tray[number], index: number, onChanged: self.wordMoved, onEnded: self.wordDropped)
                }
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("makeasentence")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 400))
    }

    
    
    func wordMoved(location: CGPoint, word: String) -> DragState {
        if wordAreaFrame.contains(location) {
        //if let match = buttonFrames.firstIndex(where: {
           //$0.contains(location) }) {
            //if activeWords[match] == word  { return .bad }
            if activeWords.firstIndex(where: { $0.contains(word)}) == nil {
                return .bad
            }
            
            if allowedWords.contains(word) {
                return .good
            } else {
                return .bad
            }
        } else {
            return .unknown
        }
    }
    
    func wordDropped(location: CGPoint, trayIndex: Int, word: String) {
        //if let match = buttonFrames.firstIndex(where: {
          //  $0.contains(location) }) {
            //activeWords[match] = word
        if wordAreaFrame.contains(location) {
            if let match = activeWords.firstIndex(where: {$0.contains(word)}){
                activeWords[match] = word
            }
            
            tray.remove(at: trayIndex)
            tray.append("")
        }
    }
}

struct WordGame_Previews: PreviewProvider {
    static var previews: some View {
        WordGame()
            .ignoresSafeArea()
    }
}
