//
//  UserProgress.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 19/09/2024.
//

import Foundation

class UserProgress: ObservableObject {
    static let shared = UserProgress()
    
    @Published var totalStars: Int = 0
    @Published var totalPoints: Int = 0
    @Published var badgesEarned: [String] = []
    
    private init() {
        loadProgress()
    }
    
    func earnStar() {
        totalStars += 1
        saveProgress()
        checkForBadges()
    }
    
    func addPoints(_ points: Int) {
        totalPoints += points
        saveProgress()
        checkForBadges()
    }
    
    func earnBadge(_ badge: String) {
        if !badgesEarned.contains(badge) {
            badgesEarned.append(badge)
            saveProgress()
        }
    }
    
    func checkForBadges() {
        if totalStars == 10 && !badgesEarned.contains("10 Stars") {
            earnBadge("10 Stars")
        }
        if totalPoints == 100 && !badgesEarned.contains("100 Points") {
            earnBadge("100 Points")
        }
        // Add more badge conditions as needed
    }
    
    private func saveProgress(){
        let defaults = UserDefaults.standard
        defaults.setValue(totalStars, forKey: "totalStars")
        defaults.setValue(totalPoints, forKey: "totalPoints")
        defaults.setValue(badgesEarned, forKey: "badgesEarned")
    }
    
    private func loadProgress() {
        let defaults = UserDefaults.standard
        totalStars = defaults.integer(forKey: "totalStars")
        totalPoints = defaults.integer(forKey: "totalPoints")
        badgesEarned = defaults.stringArray(forKey: "badgesEarned") ?? []
    }
}
