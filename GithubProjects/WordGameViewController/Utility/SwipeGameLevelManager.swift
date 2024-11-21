//
//  LevelManager.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import UIKit

class SwipeGameLevelManager {
    static let shared = SwipeGameLevelManager()
    
    private init() {} // Prevent direct instantiation
    
    private let uncorrectedLevels: [SwipeGameLevel] = [
        SwipeGameLevel(targetWords: ["BEAR", "EAR", "ARE", "BAR"], letters: "BEAR", extraWords: ["BRA", "REB"]),
        SwipeGameLevel(targetWords: ["CHAIR", "AIR", "ARC", "CHAR"], letters: "CHAIR", extraWords: ["RICH", "RAH"]),
        SwipeGameLevel(targetWords: ["STORM", "MOST", "SORT", "MORT"], letters: "STORM", extraWords: ["TORS", "ROST"]),
        SwipeGameLevel(targetWords: ["PLANE", "PLAN", "LEAP", "PANEL"], letters: "PLANE", extraWords: ["PEAL", "LEAN"]),
        SwipeGameLevel(targetWords: ["SMART", "ART", "RATS", "STAR"], letters: "SMART", extraWords: ["MARS", "TARS"]),
        SwipeGameLevel(targetWords: ["CLOUD", "COULD", "LOUD", "DUO"], letters: "CLOUD", extraWords: ["CLOD", "OLD"]),
        SwipeGameLevel(targetWords: ["SNAKE", "SKANE", "SANE", "KEAN"], letters: "SNAKE", extraWords: ["NEKS", "SNAK"]),
        SwipeGameLevel(targetWords: ["GHOST", "HOST", "SHOT", "GOSH"], letters: "GHOST", extraWords: ["THOS", "HOGS"]),
        SwipeGameLevel(targetWords: ["TRUCK", "RUT", "CUT", "CUR"], letters: "TRUCK", extraWords: ["TURK", "RUCK"]),
        SwipeGameLevel(targetWords: ["WORLD", "WORD", "LORD", "OLD"], letters: "WORLD", extraWords: ["ROWD", "WOLD"]),
        SwipeGameLevel(targetWords: ["UNIQUE", "QUEEN", "QUIET", "QUITE"], letters: "UNIQUE", extraWords: ["QUIN", "UNTIE"]),
        SwipeGameLevel(targetWords: ["INSIDE", "DINES", "SIDEN", "SNIDE"], letters: "INSIDE", extraWords: ["SINE", "DIES"]),
        SwipeGameLevel(targetWords: ["BUNDLE", "BLEND", "LUNED", "UNLED"], letters: "BUNDLE", extraWords: ["NUDE", "DEB"]),
        SwipeGameLevel(targetWords: ["MONKEY", "KEYON", "MONEY", "ONKEY"], letters: "MONKEY", extraWords: ["MONK", "YEON"]),
        SwipeGameLevel(targetWords: ["PYTHON", "TYHOP", "HYTOP", "PHONY"], letters: "PYTHON", extraWords: ["TYON", "HOPY"]),
        SwipeGameLevel(targetWords: ["CRYSTAL", "STACY", "LYCRA", "ACTY"], letters: "CRYSTAL", extraWords: ["LACY", "SCAT"]),
        SwipeGameLevel(targetWords: ["MIRAGE", "IMAGE", "GRIM", "MAGI"], letters: "MIRAGE", extraWords: ["RAGE", "AIM"]),
        SwipeGameLevel(targetWords: ["SHIELD", "DISH", "HELD", "HIDE"], letters: "SHIELD", extraWords: ["SIDLE", "LIES"]),
        SwipeGameLevel(targetWords: ["TUNNEL", "LUNTE", "TUNE", "NULL"], letters: "TUNNEL", extraWords: ["LUTE", "NELT"]),
        SwipeGameLevel(targetWords: ["GUITAR", "GRIT", "TRIG", "RAGU"], letters: "GUITAR", extraWords: ["GUT", "RIGA"]),
        SwipeGameLevel(targetWords: ["BREEZE", "BREE", "REBE", "REE", "BREEZ", "BEE"], letters: "BREEZE", extraWords: ["REEB", "BEER", "BEEZ", "ZEE"]),
        SwipeGameLevel(targetWords: ["SILENCE", "SLICE", "LINE", "INCE", "NICE", "LICE"], letters: "SILENCE", extraWords: ["SLICE", "LIES", "INCE", "CEL"]),
        SwipeGameLevel(targetWords: ["JOURNEY", "JOUR", "OURN", "URN", "NEAR", "JOUR"], letters: "JOURNEY", extraWords: ["REJ", "JOY", "URN", "YON"]),
        SwipeGameLevel(targetWords: ["MOUNTAIN", "MOUN", "NTAIN", "TAIN", "INTO", "TAUN"], letters: "MOUNTAIN", extraWords: ["MOUNT", "INTO", "TAIN", "NAUT"]),
        SwipeGameLevel(targetWords: ["RAINBOW", "RAIN", "BOW", "WAN", "BROW", "RAIN"], letters: "RAINBOW", extraWords: ["NIB", "ROW", "BAIN", "WAR"]),
        SwipeGameLevel(targetWords: ["THUNDER", "UNDER", "HUN", "DUNE", "HEN", "NUT"], letters: "THUNDER", extraWords: ["NUT", "THE", "HEN", "DUN"]),
        SwipeGameLevel(targetWords: ["MAGNETIC", "MAGNET", "GAIN", "MAG", "TEIN", "ENT"], letters: "MAGNETIC", extraWords: ["GAM", "TAN", "MINT", "NIT"]),
        SwipeGameLevel(targetWords: ["TWILIGHT", "TWIT", "LIGHT", "THIT", "WILT", "IGHT"], letters: "TWILIGHT", extraWords: ["LIT", "TIG", "WIT", "HIT"]),
        SwipeGameLevel(targetWords: ["SYMPHONY", "SYP", "PHO", "ONY", "MONEY", "PHYS"], letters: "SYMPHONY", extraWords: ["SON", "HYP", "PSY", "MON"]),
        SwipeGameLevel(targetWords: ["PHANTOM", "PHO", "TOM", "NAP", "MOTH", "ANT"], letters: "PHANTOM", extraWords: ["POT", "HAM", "TOP", "MAN"]),
        SwipeGameLevel(targetWords: ["STARDOM", "STAR", "DOOM", "ROAD", "MARS", "TOM"], letters: "STARDOM", extraWords: ["ROT", "DOM", "SAD", "MOR"]),
        SwipeGameLevel(targetWords: ["CARTOON", "TOON", "CART", "RAT", "COON", "OAT"], letters: "CARTOON", extraWords: ["ROT", "CAN", "TOO", "ARC"]),
        SwipeGameLevel(targetWords: ["JIGSAW", "JIG", "SAW", "WAS", "JAW", "GAS"], letters: "JIGSAW", extraWords: ["JIS", "JAW", "GAS", "WIG"]),
        SwipeGameLevel(targetWords: ["BRIDGED", "BID", "RIDE", "GRID", "BEG", "RID"], letters: "BRIDGED", extraWords: ["BIG", "BED", "RED", "DIG"]),
        SwipeGameLevel(targetWords: ["GOLDFISH", "GOLF", "FISH", "HOLD", "LOG", "DOG"], letters: "GOLDFISH", extraWords: ["FOG", "HIS", "HID", "GOD"]),
        SwipeGameLevel(targetWords: ["FLASHBACK", "FLASH", "BACK", "HACK", "LASH", "SACK"], letters: "FLASHBACK", extraWords: ["FLAK", "ASK", "LAB", "SKA"]),
        SwipeGameLevel(targetWords: ["CANDLESTICK", "CANDLE", "STICK", "DEAL", "NECK", "LACE"], letters: "CANDLESTICK", extraWords: ["SKID", "DIS", "LICK", "CLAD"]),
        SwipeGameLevel(targetWords: ["MEGAPHONE", "MEGA", "PHONE", "HONE", "GONE", "PHON"], letters: "MEGAPHONE", extraWords: ["GAP", "HOPE", "GEN", "EGO"]),
        SwipeGameLevel(targetWords: ["EXPLORE", "EXPO", "LORE", "ROLE", "REEL", "POLE"], letters: "EXPLORE", extraWords: ["ROPE", "ELO", "REX", "LOP"]),
        SwipeGameLevel(targetWords: ["INSURANCE", "INSURE", "ACNE", "CASE", "NICE", "RUNE"], letters: "INSURANCE", extraWords: ["RUN", "SIN", "CURE", "CAN"])
    ]
    
    func getLevels() -> Array<SwipeGameLevel> {
        validateLevels(levels: uncorrectedLevels)
    }
    
    // Function to validate letters for each level
    private func validateLevels(levels: [SwipeGameLevel]) -> [SwipeGameLevel] {
        var correctedLevels = [SwipeGameLevel]()
        for var level in levels {
            // Collect the letters from targetWords and compare with letters
            let requiredLetters = Set(level.targetWords.filter({ LanguageManager.shared.isEnglish(word: $0) }).joined())
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
