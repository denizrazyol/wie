//
//  RewardAnimationView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/09/2024.
//

import SwiftUI

struct RewardAnimationView: View {
    
    @State private var animate = false
    
    var body: some View {
           ZStack {
               Image(systemName: "star.fill")
                   .resizable()
                   .foregroundColor(Color.yellow)
                   .frame(width: 100, height: 100)
                   .scaleEffect(animate ? 1.5 : 1.0)
                   .opacity(animate ? 0.0 : 1.0)
                   .onAppear {
                       withAnimation(Animation.easeOut(duration: 1.0)) {
                           animate = true
                       }
                   }
           }
       }
}

#Preview {
    RewardAnimationView()
}
