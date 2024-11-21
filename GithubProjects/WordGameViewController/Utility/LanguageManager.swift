//
//  LanguageManager.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 21.11.2024.
//

import Foundation
import UIKit

struct LanguageManager {
    
    static let shared = LanguageManager()
    
    private init() {} // Prevent direct instantiation
    
    // Helper function checks word is real or not
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isEnglish(word: String) -> Bool {
        guard isReal(word: word) else { return false }
        
        let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
        tagger.string = word

        let range = NSRange(location: 0, length: word.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation]

        var isValidWord = false

        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { (tag, _, stop) in
            if let tag = tag, tag == .noun || tag == .verb || tag == .adjective || tag == .adverb {
                isValidWord = true
                stop.pointee = true // Stop further enumeration
            }
        }

        return isValidWord
    }
}

