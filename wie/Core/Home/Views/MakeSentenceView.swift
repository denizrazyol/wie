//
//  MakeSentenceView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct ElementModel:  Identifiable, Codable {
    let id: Int
    var text: String
    var position: CGPoint
    var isVisible: Bool
}

struct MakeSentenceView: View {
    
    @EnvironmentObject var orientationInfo: OrientationInfo
    @State private var elements: [ElementModel] = []
    @State private var tray: [String] = ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"]
    
    @State private var activeWords: [ElementModel] = []
    @State private var buttonFrames = [CGRect](repeating: .zero, count: 4)
    
    let allowedWords: [String] = ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"]
    
    let wordAreaFrame = CGRect(x: 0, y: 400, width: 400, height: 200)
    
    var body: some View {
        ZStack(){
            Image("makeasentence")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 400)
            
            
            VStack(){
                
                WrapView(elements: $elements, onChanged: self.wordMoved, onEnded: self.wordDropped)
                    .padding()
                    .frame(height: 160)
                    //.background(Color.green)
                
                Spacer()
              
             
                ZStack(alignment: .leading) {
                    
                    
                    VStack(spacing: 50){
                        LabelledDividerView(label: "Put here")
                        DividerView()
                        DividerView()
                        DividerView()
                    }
                    //.frame(width: wordAreaFrame.width, height: wordAreaFrame.height)
                    //.position(x: wordAreaFrame.midX, y: wordAreaFrame.midY)
                                
                   
                    WrapView2(elements: $activeWords)
                        .padding()
                        .frame(height: 160)
                        //.background(Color.green)

                }
                //.frame(height: 250)
                //.background(Color.blue)
                
                Spacer()
         
                Button {
                    elements.removeAll()
                    activeWords.removeAll()
                    initializeElements()
                } label: {
                        Text("Start Again")
                            .font(.headline)
                            .frame(width: 150, height: 35)
                }
                .buttonStyle(.borderedProminent )
                
                Button {
                 
                } label: {
                        Text("Next")
                            .font(.headline)
                            .frame(width: 150, height: 35)
                }
                .buttonStyle(.borderedProminent )
                    
                
            }
            .frame(height: 680)
         
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            initializeElements()
        }
    }
    
    func initializeElements() {
        let data = ["Item 8", "Item 5", "Item 2", "Item 1", "Item 4", "Item 0", "Item 6", "Item 7", "Item 3"]
        var index = 0
        var x = 90
        let y = 420
        for item in data {
            elements.append(ElementModel(id: index, text: item, position: CGPoint(x: x, y: y), isVisible: true))
      
            x += 76
            index += 1
        }
    }
    
    func wordMoved(location: CGPoint, word: String) -> DragState {
        if wordAreaFrame.contains(location) {
            //if activeWords.firstIndex(where: { $0.text.contains(word)}) == nil {
              //  return .bad
            //}
            
            if allowedWords.contains(word) {
                return .good
            } else {
                return .bad
            }
        } else {
            return .unknown
        }
    }
    
    @State private var wordId: Int = 0
    func wordDropped(location: CGPoint, trayIndex: Int, word: String) {
        if wordAreaFrame.contains(location) {
            if let match = activeWords.firstIndex(where: {$0.text.contains(word)}){
                activeWords[match].isVisible = true
            }
            
            elements.remove(at: trayIndex)
            self.wordId = self.wordId + 1
            activeWords.append(ElementModel(id: wordId, text: word, position: CGPoint(x: 90, y: 420), isVisible: true))
            //elements.append("")
        }
    }
}

struct MakeSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        MakeSentenceView()
            .ignoresSafeArea()
            .environmentObject(OrientationInfo())
    }
}
