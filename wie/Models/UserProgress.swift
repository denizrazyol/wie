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
    
    @Published var wordPlayCounts: [UUID: Int] = [:]
    
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
    }
    
    func incrementPlayCount(for wordID: UUID) {
        wordPlayCounts[wordID, default: 0] += 1
        saveProgress()
    }
    
    func playCount(for wordID: UUID) -> Int {
        return wordPlayCounts[wordID, default: 0]
    }
    
    private func saveProgress(){
        let defaults = UserDefaults.standard
        defaults.setValue(totalStars, forKey: "totalStars")
        defaults.setValue(totalPoints, forKey: "totalPoints")
        defaults.setValue(badgesEarned, forKey: "badgesEarned")
        
        if let data = try? JSONEncoder().encode(wordPlayCounts) {
            defaults.setValue(data, forKey: "wordPlayCounts")
        }
    }
    
    private func loadProgress() {
        let defaults = UserDefaults.standard
        totalStars = defaults.integer(forKey: "totalStars")
        totalPoints = defaults.integer(forKey: "totalPoints")
        badgesEarned = defaults.stringArray(forKey: "badgesEarned") ?? []
        
        if let data = defaults.data(forKey: "wordPlayCounts"),
           let decoded = try? JSONDecoder().decode([UUID: Int].self, from: data) {
            wordPlayCounts = decoded
        } else {
            wordPlayCounts = [:]
        }
    }
}
