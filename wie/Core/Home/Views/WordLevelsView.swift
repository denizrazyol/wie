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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
        .frame(maxHeight: listMaxHeight)
        .padding(.trailing, 25)
    }
}

struct WordLevelsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 15 Pro Max", "iPad (10th generation)"], id: \.self) { deviceName in
            WordLevelsView()
                .environmentObject(HomeViewModel())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

extension WordLevelsView {
    
    
    private var listMaxHeight: CGFloat? {
        horizontalSizeClass == .regular ? 280 : 210
    }
    
    private func listRowView(name: String) -> some View {
        VStack() {
            Text(name)
                .font(.custom("ChalkboardSE-Regular", size: horizontalSizeClass == .regular ? 30 : 22))
                .foregroundColor(Color.theme.accent)
    
        }
    }
}

