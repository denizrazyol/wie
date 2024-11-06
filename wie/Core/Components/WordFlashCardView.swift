//
//  WordFlashCardView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 08/11/2023.
//

import SwiftUI

struct WordFlashCardView: View {
    
    let word: WordModel
    let onPlayButtonTapped: () -> Void
    @EnvironmentObject var userProgress: UserProgress
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 3)
            
            VStack {
                Text(word.word)
                    .font(.custom("ChalkboardSE-Regular", size: 32))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        onPlayButtonTapped()
                    }) {
                        Image(systemName: "speaker.wave.2.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.theme.iconColor)
                            .padding(8)
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CircularProgressView(progress: progress)
                        .frame(width: 40, height: 40)
                        .padding(8)
                }
            }
        }
    }
    
    var progress: Double {
        let playCount = userProgress.playCount(for: word.uuid)
        let maxPlayCount = 5.0 // Set your desired max play count
        return min(Double(playCount) / maxPlayCount, 1.0)
    }
}

struct WordFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        WordFlashCardView(word: WordModel(fromString: "1, New Word")) {
            
        }
        .environmentObject(UserProgress.shared)
    }
}
