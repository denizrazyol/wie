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
            .padding(.vertical, 8)
            .padding(.trailing, 6)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            
    }
}

#Preview {
    WordBasicView(word: "Today", index: 1)
}
