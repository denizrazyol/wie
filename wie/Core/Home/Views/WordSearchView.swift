//
//  WordSearchView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct WordSearchView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    @State private var tray: [ElementModel] = [ElementModel(id: 1, text: "today", position: CGPoint(x: 10, y: 20), isVisible: true), ElementModel(id: 2, text: "were", position: CGPoint(x: 30, y: 40), isVisible: true), ElementModel(id: 1, text: "said", position: CGPoint(x: 10, y: 20), isVisible: true), ElementModel(id: 2, text: "your", position: CGPoint(x: 30, y: 40), isVisible: true), ElementModel(id: 1, text: "come", position: CGPoint(x: 10, y: 20), isVisible: true), ElementModel(id: 2, text: "some", position: CGPoint(x: 30, y: 40), isVisible: true), ElementModel(id: 1, text: "love", position: CGPoint(x: 10, y: 20), isVisible: true), ElementModel(id: 2, text: "there", position: CGPoint(x: 30, y: 40), isVisible: true),]
    
    var body: some View {
        ZStack(){
            Image("makeasentence")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 400)
            VStack(){
                GridView()
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
                    .padding(.top, 20)
                VStack(alignment: .leading){
                    HStack(alignment: .firstTextBaseline) {
                        ForEach(0..<4){ number in
                            WordBasicView(word: self.tray[number].text, index: self.tray[number].id)
                        }
                    }
                    HStack(alignment: .firstTextBaseline) {
                        ForEach(4..<8){ number in
                            WordBasicView(word: self.tray[number].text, index: self.tray[number].id)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.theme.accent))
            }
            .padding()
            .padding(.vertical,70)
        }
        
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView()
            .ignoresSafeArea()
    }
}
