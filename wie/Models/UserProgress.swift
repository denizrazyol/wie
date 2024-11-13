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
    
    @Published var wordPlayCounts: [String: Int] = [:]
    
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
    
    func incrementPlayCount(for word: String) {
        wordPlayCounts[word, default: 0] += 1
        if(wordPlayCounts[word, default: 0] == 5) {
            earnStar()
            addPoints(10)
        }
        saveProgress()
    }
    
    func playCount(for word: String) -> Int {
        return wordPlayCounts[word, default: 0]
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
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            wordPlayCounts = decoded
        } else {
            wordPlayCounts = [:]
        }
    }
}
