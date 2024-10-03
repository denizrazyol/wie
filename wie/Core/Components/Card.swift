//
//  Card.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 23/04/2024.
//

import SwiftUI

enum Status {
    case correct
    case wrong
    case empty
}

struct CardView: View {
    
    var word: String
    var maxWidth: CGFloat?
    var backgorundColor: Color?
    var status: Status
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgorundColor ?? Color.white)
                .frame(height: 140)
                .frame(maxWidth: maxWidth)
                .cornerRadius(20)
                .overlay(
                    Group {
                        switch status {
                        case .correct:
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding(10)
                        case .wrong:
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(10)
                        case .empty:
                            EmptyView()
                        }
                    },
                    alignment: .topTrailing
                )
            
            Text(word)
                .font(.custom("ChalkboardSE-Regular", size: 30))
                .minimumScaleFactor(0.3)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor((backgorundColor != nil) ? .white : .black)
                .multilineTextAlignment(.center)
                .padding(10)
        }
    }
}

#Preview {
    CardView(word: "pronunciation", maxWidth: 200, backgorundColor: nil, status: .empty)
}


#Preview {
    CardView(word: "Hello", maxWidth: 100, status: Status.empty)
}
