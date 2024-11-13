//
//  wieApp.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

@main
struct wieApp: App {

    
    @StateObject private var vm = HomeViewModel()
    //@StateObject private var userProgress = UserProgress.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                OnboardView()
                    .environmentObject(vm)
                    .environmentObject(UserProgress.shared)
                
            }
            
        }
    }
}
