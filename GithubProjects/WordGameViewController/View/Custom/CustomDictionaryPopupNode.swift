//
//  CustomDictionaryPopupNode.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 21.11.2024.
//

import Foundation
import SpriteKit

class CustomDictionaryPopupNode: SKNode {
    
    private let completion: (String) -> Void
    
    init(title: String, message: String, guessedWords: Set<String>, completion: @escaping (String) -> Void) {
        self.completion = completion
        super.init()
        
        // Background
        let screenSize = UIScreen.main.bounds.size
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: screenSize)
        background.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        background.zPosition = -1 // Ensure it's above other nodes
        background.name = "overlayBackground"
        addChild(background)
        
        // Centered container
        let containerNode = SKShapeNode(rectOf: CGSize(width: 300, height: 270), cornerRadius: 12)
        containerNode.fillColor = .white
        containerNode.strokeColor = .clear
        containerNode.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        containerNode.zPosition = 0
        addChild(containerNode)
        
        // Title Label
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = title
        titleLabel.fontSize = 24
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: screenSize.width / 2, y: containerNode.frame.maxY - 40)
        addChild(titleLabel)
        
        // Message Label (Multiline)
        let messageLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        messageLabel.text = message
        messageLabel.fontSize = 18
        messageLabel.fontColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.verticalAlignmentMode = .center
        messageLabel.preferredMaxLayoutWidth = containerNode.frame.width - 40
        messageLabel.position = CGPoint(x: titleLabel.position.x, y: titleLabel.frame.minY - 40)
        addChild(messageLabel)
        
        // Word List Layout
        let words = Array(guessedWords)
        let maxColumns = 3 // Maximum number of columns
        let horizontalMargin: CGFloat = 20
        let gap: CGFloat = 10
        let wordWidth = (containerNode.frame.width - (2 * horizontalMargin) - CGFloat(maxColumns - 1) * gap) / CGFloat(maxColumns)
        let wordHeight: CGFloat = 35
        let wordSpacing = CGSize(width: wordWidth, height: wordHeight)
        let totalWords = words.count
        let startY = messageLabel.frame.minY - 30 // Adjusted starting position
        
        for index in 0..<totalWords {
            let word = words[index]
            
            // Calculate column and row
            let row = index / maxColumns
            let col = index % maxColumns
            
            // Calculate position
            let xOffset = containerNode.frame.minX + horizontalMargin + wordSpacing.width / 2 + CGFloat(col) * (wordSpacing.width + gap)
            let yOffset = startY - CGFloat(row) * (wordSpacing.height + gap)
            
            // Word Background (Rectangle)
            let wordBackground = SKShapeNode(rectOf: wordSpacing, cornerRadius: 10)
            wordBackground.fillColor = UIColor.lightGray.withAlphaComponent(0.8) // Lighter background
            wordBackground.strokeColor = .clear
            wordBackground.position = CGPoint(x: xOffset, y: yOffset)
            wordBackground.name = "word_\(index)_animatable"
            addChild(wordBackground)
            
            // Word Label (Inside Rectangle)
            let wordLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
            wordLabel.text = word
            wordLabel.fontSize = 16
            wordLabel.fontColor = .black
            wordLabel.verticalAlignmentMode = .center
            wordBackground.addChild(wordLabel)
        }
        
        // Dismiss Button
        let button = SKShapeNode(rectOf: CGSize(width: 100, height: 40), cornerRadius: 10)
        button.fillColor = .red
        button.strokeColor = .clear
        button.position = CGPoint(x: titleLabel.position.x, y: screenSize.height - (containerNode.frame.maxY - 40))
        button.name = "dismissButton_animatable"
        addChild(button)
        
        let buttonLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        buttonLabel.text = "Dismiss"
        buttonLabel.fontSize = 18
        buttonLabel.fontColor = .white
        buttonLabel.verticalAlignmentMode = .center
        button.addChild(buttonLabel)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add button press effect
    private func animateScaleDown(_ button: SKNode) {
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        button.run(scaleDown)
    }
    
    private func animateScaleUp(_ button: SKNode) {
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        button.run(scaleUp)
    }

    // Handle touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let buttonNode = children.filter({
            $0.isKind(of: SKShapeNode.self) &&
            $0.name?.contains("_animatable") == true &&
            $0.contains(location) }).first
        if let buttonNode { animateScaleDown(buttonNode) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if a word was tapped
        for child in children {
            if let wordBackground = child as? SKShapeNode, wordBackground.name?.starts(with: "word_") == true, wordBackground.contains(location) {
                animateScaleUp(wordBackground)
                if let wordLabel = wordBackground.children.first as? SKLabelNode, let word = wordLabel.text {
                    completion(word) // Return the tapped word
                }
                return
            }
        }
        
        // Check if dismiss button was tapped
        if let dismissButton = childNode(withName: "dismissButton_animatable"), dismissButton.contains(location) {
            animateScaleUp(dismissButton) // Apply press effect
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
            // Animate
            self.run(SKAction.sequence([fadeOutAction, SKAction.removeFromParent()]))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let buttonNode = children.filter({
            $0.isKind(of: SKShapeNode.self) &&
            $0.name?.contains("_animatable") == true &&
            $0.contains(location) }).first
        if let buttonNode { animateScaleUp(buttonNode) }
    }
}
