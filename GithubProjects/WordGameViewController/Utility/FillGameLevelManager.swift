//
//  FillGameLevelManager.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 21.11.2024.
//

import Foundation

class FillGameLevelManager {
    static let shared = FillGameLevelManager()
    private let key = "FillGameLevelNumber"
    
    private var currentLevelIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: key)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
    private let levels: Array<FillGameLevel> = [
        FillGameLevel(question: "The quick brown _ jumps over the lazy dog.", correctAnswer: "fox", answers: ["cat", "dog", "fox"]),
        FillGameLevel(question: "To be, or not to be, that is the _.", correctAnswer: "question", answers: ["answer", "question", "thought"]),
        FillGameLevel(question: "The capital of France is _.", correctAnswer: "Paris", answers: ["Berlin", "Paris", "Rome"])
    ]
    
    private init() {} // Prevent direct instantiation
    
    func getCurrentLevel() -> FillGameLevel {
        return levels[currentLevelIndex]
    }
    
    func nextLevel() {
        currentLevelIndex += 1
    }
    
    func isLastLevel() -> Bool {
        return currentLevelIndex >= levels.count - 1
    }
}
