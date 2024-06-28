//
//  WordSearchView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct WordSearchView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var foundWords = Set<Int>()
    @State private var gameCompleted = false
    @State private var showNewGameMessage = false
    
    var body: some View {
        
        let tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
        
        VStack(){
            if showNewGameMessage {
                
                VStack {
                    Text("Great Job! 🎉 You've found all the words!")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .scaleEffect(gameCompleted ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: gameCompleted)
                    
             
                }
                .transition(.scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        vm.resetGame()
                        gameCompleted = false
                        showNewGameMessage = false
                    }
                }
            } else {
            
                GridView(wordModelList: tray, 
                         onCompletion: {
                            gameCompleted = true
                            showNewGameMessage = true
                    })
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .shadow(color: Color.gray.opacity(0.5), radius: 20)
                    .padding(.bottom,10)
            
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                    
                        ForEach(0..<3){ number in
                            WordBasicView(word: tray[number].word, index: tray[number].id)
                                .onTapGesture {
                                    vm.markWordAsFound(tray[number].id)
                                    checkCompletion()
                                }
                        }
                    
                    }
                HStack(alignment: .top) {
                    
                    ForEach(3..<6){ number in
                        WordBasicView(word: tray[number].word, index: tray[number].id)
                            .onTapGesture {
                                vm.markWordAsFound(tray[number].id)
                                checkCompletion()
                            }
                    }
                }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent))
             }
            }
            .padding()
        }
    
    func checkCompletion() {
        if vm.foundWords.count == 6 {
            gameCompleted = true
            showNewGameMessage = true
        }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView().environmentObject(HomeViewModel())
            
    }
}
