//
//  FillInTheBlankScene.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import Foundation
import SpriteKit

class FillInTheBlankScene: SKScene {
    
    private var questionLabel: SKLabelNode!
    private var answerNodes: [SKLabelNode] = []
    private var currentAnswerNode: SKLabelNode?
    private var closeButton: SKSpriteNode!
    private var originalPositions: [CGPoint] = []
    private let gameManager = FillGameLevelManager.shared
    
    override func didMove(to view: SKView) {
        setupUI()
        loadLevel()
    }
    
    func setupUI() {
        // Set up question label
        questionLabel = SKLabelNode(fontNamed: "Chalkduster")
        questionLabel.fontSize = 26
        questionLabel.position = CGPoint(x: size.width / 2, y: size.height - 150)
        questionLabel.preferredMaxLayoutWidth = size.width * 0.80
        questionLabel.numberOfLines = 0
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.verticalAlignmentMode = .center
        addChild(questionLabel)
        
        // Set up answer labels
        let answerPositions = [
            CGPoint(x: size.width / 2 - 100, y: 100),
            CGPoint(x: size.width / 2, y: 100),
            CGPoint(x: size.width / 2 + 100, y: 100)
        ]
        
        for position in answerPositions {
            let answerNode = SKLabelNode(fontNamed: "Chalkduster")
            answerNode.fontSize = 24
            answerNode.position = position
            answerNode.name = "answer_\(position)"
            answerNodes.append(answerNode)
            originalPositions.append(position)
            addChild(answerNode)
        }
        
        setupCloseButton()
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
    
    private func dismissGameScene() {
        NavigationManager.shared.returnToMenuScene()
    }
    
    func loadLevel() {
        let currentLevel = gameManager.getCurrentLevel()
        questionLabel.text = currentLevel.question
        
        for (index, answer) in currentLevel.answers.enumerated() {
            answerNodes[index].text = answer
            answerNodes[index].position = originalPositions[index]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if closeButton.frame.contains(touchLocation) {
            dismissGameScene()
            return
        }
        
        if let node = atPoint(touchLocation) as? SKLabelNode,
           node.name?.contains("answer_") == true {
            currentAnswerNode = node
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let currentAnswerNode else {
            return
        }
        
        currentAnswerNode.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentAnswerNode else {
            return
        }
        
        if currentAnswerNode.text == gameManager.getCurrentLevel().correctAnswer {
            // Show filled question and transition to next level
            let currentLevel = gameManager.getCurrentLevel()
            let filledQuestion = currentLevel.question.replacingOccurrences(of: "_", with: currentAnswerNode.text!)
            questionLabel.text = filledQuestion
            
            // Fade out the correct answer node
            let fadeOut = SKAction.fadeOut(withDuration: 1.0)
            currentAnswerNode.run(fadeOut) { [weak self] in
                self?.moveToNextLevel()
            }
        } else {
            // Handle incorrect answer
            let originalPosition = originalPositions[answerNodes.firstIndex(of: currentAnswerNode)!]
            let moveAction = SKAction.move(to: originalPosition, duration: 0.5)
            currentAnswerNode.run(moveAction)
            
            showToast(message: "Incorrect! Please try again.")
        }
        // Release current answer
        self.currentAnswerNode = nil
    }
    
    func moveToNextLevel() {
        if gameManager.isLastLevel() {
            print("Congratulations! You've completed all levels.")
        } else {
            gameManager.nextLevel()
            loadLevel()
        }
    }
    
    func showToast(message: String) {
        let toastLabel = SKLabelNode(fontNamed: "Chalkduster")
        toastLabel.text = message
        toastLabel.fontSize = 24
        toastLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        toastLabel.alpha = 0
        addChild(toastLabel)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        
        toastLabel.run(sequence)
    }
}
