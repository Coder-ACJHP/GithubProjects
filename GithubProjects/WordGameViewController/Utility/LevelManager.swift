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
    
    let levels: [Level] = [
        Level(targetWords: ["BEAR", "BEE", "EAR", "REE"], letters: "BEARE"),
        Level(targetWords: ["ENLIGHT", "LITE", "NIGHT", "LIT"], letters: "ENLIGHT"),
        Level(targetWords: ["FROST", "ROTS", "SORT", "TO"], letters: "FROST"),
        Level(targetWords: ["GREAT", "RATE", "TEAR", "GRAT"], letters: "GREAT"),
        Level(targetWords: ["WATCH", "HAT", "ACT", "TACK"], letters: "WATCH"),
        Level(targetWords: ["MOUNT", "TUN", "MUT", "MOT"], letters: "MOUNT"),
        Level(targetWords: ["BLOOM", "LOOM", "MOB", "BOM"], letters: "BLOOM"),
        Level(targetWords: ["BRIGHT", "RIGHT", "BIRG", "THIR"], letters: "BRIGHT"),
        Level(targetWords: ["PLANT", "PLAN", "LANT", "ANT"], letters: "PLANT"),
        Level(targetWords: ["HOUSE", "HOES", "SHE", "SO"], letters: "HOUSE"),
        Level(targetWords: ["THRILL", "TILL", "HIT", "LIR"], letters: "THRILL"),
        Level(targetWords: ["STORM", "MORT", "TORM", "ROTS"], letters: "STORM"),
        Level(targetWords: ["EXACT", "CATE", "TAC", "TEA"], letters: "EXACT"),
        Level(targetWords: ["BALLOON", "LONE", "BONE", "LOON"], letters: "BALLOON"),
        Level(targetWords: ["FALLEN", "FEL", "ALE", "ALL"], letters: "FALLEN"),
        Level(targetWords: ["WINTER", "TIN", "TIER", "RIT"], letters: "WINTER"),
        Level(targetWords: ["SHORE", "ROSE", "HOES", "RHO"], letters: "SHORE"),
        Level(targetWords: ["PAPER", "REAP", "RAPE", "PEAR"], letters: "PAPER"),
        Level(targetWords: ["ORDER", "ROD", "RED", "ORE"], letters: "ORDER"),
        Level(targetWords: ["IMPACT", "MICE", "TIMP", "ACT"], letters: "IMPACT"),
        Level(targetWords: ["STAGE", "GATE", "TAGS", "SAG"], letters: "STAGE"),
        Level(targetWords: ["HUMOR", "MOOR", "ROOM", "MOR"], letters: "HUMOR"),
        Level(targetWords: ["SWORD", "WORD", "ROD", "SORE"], letters: "SWORD"),
        Level(targetWords: ["ELECT", "CETE", "LECT", "TEC"], letters: "ELECT"),
        Level(targetWords: ["CIRCLE", "LICE", "RICE", "ICE"], letters: "CIRCLE"),
        Level(targetWords: ["VISUAL", "VIAL", "SILL", "VIL"], letters: "VISUAL"),
        Level(targetWords: ["ENJOY", "JOIN", "NO", "JOE"], letters: "ENJOY"),
        Level(targetWords: ["LEARN", "EAR", "NEAR", "RAN"], letters: "LEARN"),
        Level(targetWords: ["MAGIC", "CAM", "MIG", "GIM"], letters: "MAGIC"),
        Level(targetWords: ["GRATE", "GATE", "GRAT", "TEA"], letters: "GRATE"),
        Level(targetWords: ["TIGER", "RITE", "TIER", "GIR"], letters: "TIGER")
    ]


}
