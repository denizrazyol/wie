//
//  WordSearchView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct WordSearchView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        
        let tray = Array(vm.currentWordLevel.wordlist.shuffled().prefix(6))
        
            VStack(){
                GridView(wordModelList: tray)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .shadow(color: Color.gray.opacity(0.5), radius: 20)
                    .padding(.bottom,10)
                
                VStack(alignment: .center){
                    HStack(alignment: .top) {
                      
                        ForEach(0..<3){ number in
                            WordBasicView(word: tray[number].word, index: tray[number].id)
                        }
                      
                    }
                    HStack(alignment: .top) {
                 
                        ForEach(3..<6){ number in
                            WordBasicView(word: tray[number].word, index: tray[number].id)
                        }
                       
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.accent))
            }
            .padding()
        }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView().environmentObject(HomeViewModel())
            
    }
}
