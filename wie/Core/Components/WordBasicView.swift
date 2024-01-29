//
//  WordBasicView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 25/01/2024.
//

import SwiftUI

struct WordBasicView: View {
    
    var word: String
    var index : Int
    
    
    var body: some View {
        Text(word)
            .padding(.all, 10)
            .font(.title2)
            .foregroundColor(Color.white)
            
    }
}

#Preview {
    WordBasicView(word: "Today", index: 1)
}
