//
//  SwipeGameState.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import Foundation

struct SwipeGameState: Codable {
    let level: Int
    let diamonds: Int
    let guessedWords: [String]
    let extraWords: [String]
    let guessedExtraWords: [String]
    let hintsUsed: [String] // Store the actual letters, not just the count
    let targetWords: [String]
}
