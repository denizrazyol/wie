//
//  MainView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/09/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
                    OnboardView()
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Words")
                        }
                    BadgesView()
                        .tabItem {
                            Image(systemName: "star.circle")
                            Text("Badges")
                        }
                }
    }
}

#Preview {
    MainView()
}
