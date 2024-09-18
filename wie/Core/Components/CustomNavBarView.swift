//
//  CustomNavBarView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 18/03/2024.
//

import SwiftUI

struct CustomNavBarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let showBackButton: Bool
    let title: String
    let subTitle: String?
    
    var body: some View {
        HStack{
            if showBackButton {
                backButton
            }
            
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton
                    .opacity(0)
            }
        }
        .padding()
        .accentColor(.white)
        .foregroundColor(.white)
        .font(.headline)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.yellow, Color.theme.accent]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea(edges: .top)
        )
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarView(showBackButton: true, title: "Title here", subTitle: "SubTitle here")
            Spacer()
        }
    }
}

extension CustomNavBarView {
    
    private var backButton: some View {
        Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
                    .padding()
                    .background(Color.theme.iconColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            })
    }
    
    private var titleSection: some View {
        HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                VStack(spacing: 4) {
                    Text(title)
                        .font(.custom("ChalkboardSE-Regular", size: 28))
                        //.font(.system(size: 28, weight: .bold))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    if let subTitle = subTitle {
                        Text(subTitle)
                            .font(.system(size: 18))
                    }
                }
            }
    }
}
