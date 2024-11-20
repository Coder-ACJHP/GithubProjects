//
//  LevelManager.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation

class LevelManager {
    static let shared = LevelManager()
    
    private init() {} // Prevent direct instantiation
    
    private let uncorrectedLevels: [Level] = [
        Level(targetWords: ["BEAR", "BEE", "EAR", "REE"], letters: "BEARE"),
        Level(targetWords: ["APPLE", "PEAR", "PALE", "LEAP", "LAP", "PAL"], letters: "APPLEPR"),
        Level(targetWords: ["ENLIGHT", "LITE", "NIGHT", "LIT"], letters: "ENLIGHT"),
        Level(targetWords: ["FROST", "ROTS", "SORT", "TO"], letters: "FROST"),
        Level(targetWords: ["GRAPE", "PAGE", "PEAR", "GAP", "RAP", "APE"], letters: "GRAPEAR"),
        Level(targetWords: ["GREAT", "RATE", "TEAR", "GRAT"], letters: "GREAT"),
        Level(targetWords: ["WATCH", "HAT", "ACT", "TACK"], letters: "WATCHK"),
        Level(targetWords: ["MANGO", "GOAL", "MOAN", "MAN", "AGO", "OAK"], letters: "MANGOLK"),
        Level(targetWords: ["MATH", "HAM", "HAT", "AM", "AT", "MA"], letters: "MATH"),
        Level(targetWords: ["MOUNT", "TUN", "MUT", "MOT"], letters: "MOUNT"),
        Level(targetWords: ["BLOOM", "LOOM", "MOB", "BOM"], letters: "BLOOM"),
        Level(targetWords: ["BRIGHT", "RIGHT", "BIRG", "THIR"], letters: "BRIGHT"),
        Level(targetWords: ["PLANT", "PLAN", "LANT", "ANT"], letters: "PLANT"),
        Level(targetWords: ["HOUSE", "HOES", "SHE", "SO"], letters: "HOUSE"),
        Level(targetWords: ["LOGIC", "COIL", "COG", "OIL", "GILL", "CLOG"], letters: "LOGIC"),
        Level(targetWords: ["THRILL", "TILL", "HIT", "LIR"], letters: "THRILL"),
        Level(targetWords: ["STORM", "MORT", "TORM", "ROTS"], letters: "STORM"),
        Level(targetWords: ["EXACT", "CATE", "TAC", "TEA"], letters: "EXACTE"),
        Level(targetWords: ["BALLOON", "LONE", "BONE", "LOON"], letters: "BALLOONE"),
        Level(targetWords: ["FALLEN", "FEL", "ALE", "ALL"], letters: "FALLEN"),
        Level(targetWords: ["WINTER", "TIN", "TIER", "RIT"], letters: "WINTER"),
        Level(targetWords: ["VISUAL", "VIAL", "SILVA", "VIA", "SLAV", "AIL"], letters: "VISUAL"),
        Level(targetWords: ["SHORE", "ROSE", "HOES", "RHO"], letters: "SHORE"),
        Level(targetWords: ["PAPER", "REAP", "RAPE", "PEAR"], letters: "PAPER"),
        Level(targetWords: ["ORDER", "ROD", "RED", "ORE"], letters: "ORDER"),
        Level(targetWords: ["IMPACT", "MICE", "TIMP", "ACT"], letters: "IMPACTE"),
        Level(targetWords: ["STAGE", "GATE", "TAGS", "SAG"], letters: "STAGE"),
        Level(targetWords: ["LEMON", "MELON", "LONE", "MEN", "ONE", "EON"], letters: "LEMON"),
        Level(targetWords: ["HUMOR", "MOOR", "ROOM", "MOR"], letters: "HUMOR"),
        Level(targetWords: ["SWORD", "WORD", "ROD", "SORE"], letters: "SWORDE"),
        Level(targetWords: ["ELECT", "CETE", "LECT", "TEC"], letters: "ELECT"),
        Level(targetWords: ["ORANGE", "RANGE", "EARN", "ROAN", "RAGE", "AGREE"], letters: "ORANGE"),
        Level(targetWords: ["CIRCLE", "LICE", "RICE", "ICE"], letters: "CIRCLE"),
        Level(targetWords: ["VISUAL", "VIAL", "SILL", "VIL"], letters: "VISUALL"),
        Level(targetWords: ["ENJOY", "JOIN", "NO", "JOE"], letters: "ENJOYI"),
        Level(targetWords: ["LEARN", "EAR", "NEAR", "RAN"], letters: "LEARN"),
        Level(targetWords: ["BERRY", "BYE", "RELY", "RYE", "BEY", "YER"], letters: "BERRYLY"),
        Level(targetWords: ["MAGIC", "CAM", "MIG", "GIM"], letters: "MAGIC"),
        Level(targetWords: ["GRATE", "GATE", "GRAT", "TEA"], letters: "GRATE"),
        Level(targetWords: ["TIGER", "RITE", "TIER", "GIR"], letters: "TIGER")
    ]
    
    func getLevels() -> Array<Level> {
        validateLevels(levels: uncorrectedLevels)
    }
    
    // Function to validate letters for each level
    private func validateLevels(levels: [Level]) -> [Level] {
        var correctedLevels = [Level]()
        for var level in levels {
            // Collect the letters from targetWords and compare with letters
            let requiredLetters = Set(level.targetWords.joined())
            let providedLetters = Set(level.letters)

            if !requiredLetters.isSubset(of: providedLetters) {
                // Fix letters to include all required letters
                let missingLetters = requiredLetters.subtracting(providedLetters)
                level.letters += String(missingLetters)
            }
            correctedLevels.append(level)
        }
        return correctedLevels
    }
}
