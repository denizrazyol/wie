//
//  WordLevelsView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 15/11/2023.
//

import SwiftUI

struct WordLevelsView: View {
    
    @State private var selection: String?
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
            List {
                ForEach(vm.wordLevels) { level in
                   
                    Button {
                        vm.showNextSet(wordLevel: level)
                    } label: {
                        listRowView(name: level.name)
                          
                    }
                    .listRowBackground(Color.clear)
               
                }
            }
            .listStyle(PlainListStyle())
            .frame(maxHeight: 200)
            .padding(.trailing,25)
    }
}

struct WordLevelsView_Previews: PreviewProvider {
    static var previews: some View {
        WordLevelsView()
            .environmentObject(HomeViewModel())
    }
}

extension WordLevelsView {
        
    private func listRowView(name: String) -> some View {
         
        VStack(alignment: .leading, spacing: 0) {
            Text(name)
                .font(.custom("ChalkboardSE-Regular", size: 22))
                //.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.theme.accent)
        }
    }
    
}
