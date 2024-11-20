//
//  FillInTheBlankScene.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import Foundation
import SpriteKit

class FillInTheBlankScene: SKScene {
    
    private var closeButton: SKSpriteNode!
    private var wordToGuess: String = "EXAMPLE" // The word the user needs to guess
    private var blankSpaces: [SKLabelNode] = [] // To store blank spaces for the word
    private var userInput: String = "" // To track the user input for the current word
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Set up the blank spaces for the word
        setupBlankSpaces()
        setupCloseButton()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        // Remove all child nodes
        self.removeAllChildren()
        // Remove all actions
        self.removeAllActions()
    }
    
    func setupBlankSpaces() {
        let spaceWidth: CGFloat = 40
        let startX: CGFloat = self.size.width / 2 - CGFloat(wordToGuess.count * 20) / 2
        
        for (index, letter) in wordToGuess.enumerated() {
            let blankSpace = SKLabelNode(text: "_")
            blankSpace.fontSize = 36
            blankSpace.position = CGPoint(x: startX + CGFloat(index) * spaceWidth, y: self.size.height / 2)
            blankSpace.zPosition = 1
            blankSpaces.append(blankSpace)
            addChild(blankSpace)
        }
        
        // You can add buttons, labels, etc., here for the game interface.
    }
    
    private func setupCloseButton() {
        // Create "X" button
        let texture = SKTexture(image: UIImage(resource: .circleDismiss))
        closeButton = SKSpriteNode(texture: texture)
        closeButton.setScale(1.2)
        closeButton.position = CGPoint(x: size.width - 30, y: size.height - 55)
        closeButton.name = "closeButton"
        
        // Add the close button to the scene
        addChild(closeButton)
    }
    
    func handleUserInput(letter: String) {
        // Check if the letter is in the word
        for (index, char) in wordToGuess.enumerated() {
            if String(char) == letter {
                blankSpaces[index].text = letter // Fill in the correct blank
            }
        }
    }
    
    // You can add a button to submit answers, etc.
    func checkIfCompleted() -> Bool {
        return !blankSpaces.contains { $0.text == "_" }
    }
    
    private func dismissGameScene() {
        NavigationManager.shared.returnToMenuScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        // Reset the flag
        switch touchLocation {
        case let point where closeButton.frame.contains(point):
            dismissGameScene()
        default: break
        }
    }
}
