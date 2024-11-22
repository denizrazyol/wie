//
//  wieApp.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

import AVFoundation

func configureAudioSession() {
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        try AVAudioSession.sharedInstance().setActive(true)
        print("Audio session configured.")
    } catch {
        print("Failed to set audio session category: \(error.localizedDescription)")
    }
}

@main
struct wieApp: App {

    
    @StateObject private var vm = HomeViewModel()
    @StateObject private var userProgress = UserProgress.shared
    
    init() {
           configureAudioSession()
       }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                OnboardView()
                    .environmentObject(vm)
                    .environmentObject(userProgress)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
