//
//  CommonExceptionWordsView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct CommonExceptionWordsView: View {
    
    @StateObject private var vm = HomeViewModel()
    @State private var selection: String?
    @State private var selectedWord: WordModel = WordModel(fromString: "")
    let maxWidthForIpad: CGFloat = 700

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding()
                //.frame(maxWidth: maxWidthForIpad)
            List {
                ForEach(vm.currentWordLevel.wordlist) { word in
                    Button(action: {
                        self.selection = "destination"
                        self.selectedWord =  word
                    }) {
                        WordFlashCardView(word: word)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
            }
            .listStyle(PlainListStyle())
            .background(NavigationLink(destination: MakeAWordWithLetters(word: selectedWord), tag: "destination", selection: $selection) { EmptyView() })
        }
          
    }
}

struct CommonExceptionWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CommonExceptionWordsView()
    }
}


extension CommonExceptionWordsView {
    private var header: some View {
        VStack {
            Button(action: vm.toogleWordsList) {
                Text(vm.currentWordLevel.name)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showWordsList ? 180 : 0))
                    }
            }
                
            if vm.showWordsList {
                WordLevelsView().environmentObject(vm)
            }
         
        }
        .background(.thickMaterial)
        .cornerRadius(20)
        //.shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        
    }
}
