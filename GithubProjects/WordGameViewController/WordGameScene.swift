//
//  WordGameScene.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import UIKit
import SpriteKit

class WordGameScene: SKScene {
    
    // UI Elements
    private var wordSlots: [CustomLabelNode] = [] // Slots for the target words
    private var letterNodes: [CustomLabelNode] = [] // Letters at the bottom
    private var currentLetterPath: [CustomLabelNode] = [] // Tracks the user's current swipe path
    
    private var lastTouchLocation: CGPoint?
    private var currentLinePath: CGMutablePath!
    private var swipeLine = SKShapeNode()
    
    // Game State
    private var targetWords: [String] = [] // Words for the current level
    private var guessedWords: Set<String> = [] // Words guessed by the player
    private var letterPool: String = "" // Pool of letters to display
    private var isWordFound: Bool = false // Used for animation
    
    // Close Button
    private var closeButton: SKLabelNode!
    private var shuffleButton: SKLabelNode!
    
    // Level Data
    private var currentLevel: Int = 1
    private let levels = LevelManager.shared.levels
    private let rowCount = 6
    private let columnCount = 7
    
    override func didMove(to view: SKView) {
        loadLevel(currentLevel)
    }
    
    func loadLevel(_ level: Int) {
        // Clear previous level state
        removeAllChildren()
        wordSlots = []
        letterNodes = []
        currentLetterPath = []
        guessedWords = []
        
        guard level - 1 < levels.count else {
            print("All levels completed!")
            return
        }
        
        let levelData = levels[level - 1]
        targetWords = levelData.targetWords
        letterPool = levelData.letters
        
        setupWordSlots()
        setupLetterNodes()
        configureSwipeLine()
        setupCloseButton()
        setupShuffleButton()
    }
    
    // MARK: - Configure UI
    
    private func configureSwipeLine() {
        swipeLine.strokeColor = .white
        swipeLine.lineWidth = 8
        swipeLine.lineCap = .round
        swipeLine.lineJoin = .round
        swipeLine.name = "SwipLineNode"
        
        currentLinePath = CGMutablePath()
        swipeLine.path = currentLinePath
        
        addChild(swipeLine)
    }
    
    private func setupCloseButton() {
        // Create "X" button
        closeButton = SKLabelNode(text: "X")
        closeButton.fontSize = 25
        closeButton.fontColor = .white
        closeButton.position = CGPoint(x: size.width - 40, y: size.height - 80)
        closeButton.name = "closeButton"
        
        // Add the close button to the scene
        addChild(closeButton)
    }
    
    private func setupShuffleButton() {
        shuffleButton = SKLabelNode(text: "Shuffle")
        shuffleButton.fontSize = 18
        shuffleButton.fontColor = .white
        shuffleButton.position = CGPoint(x: size.width - 60, y: 50)
        shuffleButton.name = "shuffleButton"
        
        // Add the shuffle button to the scene
        addChild(shuffleButton)
    }
    
    private func setupWordSlots() {
        let topMargin: CGFloat = size.height * 0.85 // Position the word slots near the top
        let spacing: CGFloat = 10 // Spacing between squares
        let availableWidth = self.size.width - (spacing * 9)
        let squareSize: CGFloat = availableWidth / CGFloat(columnCount) // Size of each rounded square
        let wordSpacing = squareSize + spacing // Spacing between words
        
        // Slot pathes
        for index in 0 ..< rowCount {
            // Calculate the starting position to center the word
            let startX = spacing * 4
            let yPosition = topMargin - CGFloat(index) * wordSpacing
            
            for charIndex in 0 ..< columnCount {
                
                let label = CustomLabelNode(
                    text: "",
                    fontSize: 35,
                    fontColor: .white,
                    backgroundColor: .darkGray,
                    borderColor: .darkGray,
                    cornerRadius: 8
                )
                label.position = CGPoint(x: startX + CGFloat(charIndex) * (squareSize + spacing), y: yPosition)
                // Add the square to the scene
                addChild(label)
            }
        }
        
        // Real slots
        
        for (wordIndex, word) in targetWords.enumerated() {
            // Calculate the starting position to center the word
            let startX = spacing * 4
            let yPosition = topMargin - CGFloat(wordIndex) * wordSpacing
            
            for (charIndex, _) in word.enumerated() {
                
                let label = CustomLabelNode(
                    text: "",
                    fontSize: 35,
                    fontColor: .white,
                    backgroundColor: .black,
                    borderColor: .white,
                    cornerRadius: 8
                )
                label.position = CGPoint(x: startX + CGFloat(charIndex) * (squareSize + spacing), y: yPosition)
                label.name = "slotSquare_\(wordIndex)_\(charIndex)" // Unique name for the square
                // Add the square to the scene
                addChild(label)
            }
        }
    }
    
    private func setupLetterNodes() {
        let availableWidth = size.width * 0.7 // Subtract left (20px) and right (20px) padding
        let radius: CGFloat = availableWidth / 2 // Maximum radius based on available width
        let angleStep = CGFloat.pi * 2 / CGFloat(letterPool.count) // Angle between letters for full circle
        let startAngle = -CGFloat.pi / 2 // Start at the top of the circle (upside down)
        let squareSize: CGFloat = 40 // Size of each rounded square
        let shuffledLetters = letterPool.shuffled()
        
        // Use the dynamic radius based on the number of letters
        let dynamicRadius = min(radius, CGFloat(letterPool.count) * 35) // Use 35 as a factor for spacing
        
        // Calculate the center point
        let bottomCenter = CGPoint(x: size.width / 2, y: size.height * 0.25) // Center of the circle
        
        for (index, char) in shuffledLetters.enumerated() {
            let angle = startAngle + CGFloat(index) * angleStep
            let x = bottomCenter.x + dynamicRadius * cos(angle)
            let y = bottomCenter.y + dynamicRadius * sin(angle)
            let position = CGPoint(x: x, y: y)
            
            let letterNode = CustomLabelNode(
                size: CGSize(width: squareSize, height: squareSize),
                text: String(char),
                fontSize: 35,
                fontColor: .white,
                backgroundColor: .black,
                borderColor: .white,
                cornerRadius: 8
            )
            letterNode.position = position
            letterNode.name = "letter_\(String(char))"

            // Add the square to the scene
            addChild(letterNode)
            letterNodes.append(letterNode)
        }
    }
    
    // MARK: - Game functionalities
    
    private func showAlreadyFoundMessage() {
        // Create the label for the message
        let messageLabel = SKLabelNode(text: "You've already\nguessed that word.")
        messageLabel.fontSize = 24
        messageLabel.fontColor = .yellow
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.verticalAlignmentMode = .center
        messageLabel.numberOfLines = 0
        messageLabel.alpha = 0
        addChild(messageLabel)
        
        // Animate the message label to fade in and then out
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
        
        // Run the sequence and then remove the message label
        messageLabel.run(sequence) {
            messageLabel.removeFromParent() // Remove the label after the animation
        }
    }
    
    private func dismissGame() {
        // Dismiss the current game scene and go back to the previous view controller
        if let viewController = self.view?.window?.rootViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func shuffleLetters() {
        // Step 1: Shuffle the letter nodes array
        let shuffledNodes = letterNodes.shuffled()
        
        // Step 2: Calculate positions for the shuffled nodes in a circular layout
        let availableWidth = size.width * 0.7 // Subtract left (20px) and right (20px) padding
        let radius: CGFloat = availableWidth / 2 // Maximum radius based on available width
        let angleStep = CGFloat.pi * 2 / CGFloat(letterPool.count) // Angle between letters for full circle
        let startAngle = -CGFloat.pi / 2 // Start at the top of the circle (upside down)
        // Use the dynamic radius based on the number of letters
        let dynamicRadius = min(radius, CGFloat(letterPool.count) * 35) // Use 35 as a factor for spacing
        
        // Calculate the center point
        let bottomCenter = CGPoint(x: size.width / 2, y: size.height * 0.25) // Center of the circle
        
        // Create an array of new positions
        let newPositions = shuffledNodes.indices.map { index -> CGPoint in
            let angle = startAngle + CGFloat(index) * angleStep
            let x = bottomCenter.x + dynamicRadius * cos(angle)
            let y = bottomCenter.y + dynamicRadius * sin(angle)
            return CGPoint(x: x, y: y)
        }
        
        // Step 3: Animate each node to its new position with a circular rotation effect
        for (index, node) in shuffledNodes.enumerated() {
            let newPosition = newPositions[index]
            
            // Create a rotation animation path
            let rotationPath = CGMutablePath()
            let currentPosition = node.position
            rotationPath.addArc(
                center: bottomCenter,
                radius: radius,
                startAngle: atan2(currentPosition.y - bottomCenter.y, currentPosition.x - bottomCenter.x),
                endAngle: atan2(newPosition.y - bottomCenter.y, newPosition.x - bottomCenter.x),
                clockwise: false
            )
            
            // Create the animation actions
            let followPathAction = SKAction.follow(rotationPath, asOffset: false, orientToPath: false, duration: 0.5)
            let moveToNewPositionAction = SKAction.move(to: newPosition, duration: 0.5)
            // Combine the actions into a sequence
            let animation = SKAction.group([followPathAction, moveToNewPositionAction])
            // Run the animation
            node.run(animation)
        }
        // Step 4: Update the letterNodes array to reflect the new order
        letterNodes = shuffledNodes
    }
    
    private func connectLinesIfNeeded(currentLocation location: CGPoint) {
        // Update the line path
        let points = currentLetterPath.map { $0.center } // Get the center of each letter node
        // Ensure the points array has at least one point
        if points.count > 0 {
            // Reset the current line path
            currentLinePath = CGMutablePath()
            // Start the line from the first letter node position (center of the first node)
            let firstLetterPosition = points.first!
            currentLinePath.move(to: firstLetterPosition)
            // Draw the line between each letter node
            for (index, point) in points.enumerated() {
                // Connect points with a straight line
                if index > 0 { currentLinePath.addLine(to: point) }
            }
            // Add a straight line to the current touch location
            currentLinePath.addLine(to: location)
            // Update the swipeLine's path
            swipeLine.path = currentLinePath
        }
    }
    
    private func fillWordSlot(_ word: String) {
        guard let wordIndex = targetWords.firstIndex(of: word) else { return }
        
        for (charIndex, char) in word.enumerated() {
            // Find the corresponding label inside the square
            let squareName = "slotSquare_\(wordIndex)_\(charIndex)"
            if let label = childNode(withName: squareName) as? CustomLabelNode {
                label.text = String(char) // Set the letter
                label.labelNode.alpha = 0 // Start with alpha 0
                label.labelNode.run(SKAction.fadeIn(withDuration: 0.3)) // Animate fade-in
            }
        }
    }
    
    // MARK: - Game State Checkers
    
    private func checkWordIsFoundNowOrAlreadyFounded() {
        let formedWord = currentLetterPath.map { $0.text! }.joined()
        if targetWords.contains(formedWord), !guessedWords.contains(formedWord) {
            guessedWords.insert(formedWord)
            fillWordSlot(formedWord)
            isWordFound = true
        } else if guessedWords.contains(formedWord) {
            // If the word has already been guessed, show the message
            showAlreadyFoundMessage()
        }
    }
    
    private func resetInteractedLetters() {
        currentLetterPath.forEach {
            $0.fontColor = .white
            $0.run(SKAction.scale(to: 1.0, duration: 0.3))
        }
        currentLetterPath = []
    }
    
    private func resetSwipeLinePath() {
        let changeColor = SKAction.customAction(withDuration: 0.3) { [weak self] _, _ in
            guard let self else { return }
            swipeLine.strokeColor = isWordFound ? .green : .red
        }
        let resetColor = SKAction.customAction(withDuration: 0.3) { [weak self] _, _ in
            guard let self else { return }
            swipeLine.strokeColor = .white
            swipeLine.path = nil // Optionally clear the line when touch ends
        }
        let animation = SKAction.sequence([changeColor, resetColor])
        swipeLine.run(animation)
        currentLinePath = CGMutablePath() // Reset for the next line
        lastTouchLocation = nil // Reset the last touch location
    }
    
    private func runNextLevelIfNeeded() {
        if guessedWords.count == targetWords.count {
            currentLevel += 1
            loadLevel(currentLevel)
        }
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        // Reset the flag
        isWordFound = false
        // Check if the "X" button is tapped
        if closeButton.frame.contains(touchLocation) {
            dismissGame()
        } else if shuffleButton.frame.contains(touchLocation) {
            shuffleLetters()
        } else  if let touchedNode = atPoint(touchLocation) as? CustomLabelNode,
            letterNodes.contains(touchedNode) {
            currentLinePath = CGMutablePath() // Start a new path
            currentLinePath.move(to: touchedNode.center) // Start the path at the touch location
            lastTouchLocation = touchedNode.center // Set the first touch location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if the touch location is over any letterNode and it's not already part of the currentLetterPath
        for letterNode in letterNodes {
            if letterNode.contains(location), !currentLetterPath.contains(letterNode) {
                // Append the new letter node to the path
                currentLetterPath.append(letterNode)
                // Apply a scale and highlight effect on the selected letter
                letterNode.run(SKAction.scale(to: 1.2, duration: 0.1))
                letterNode.fontColor = .yellow
            }
        }
        
        // Draw lines
        connectLinesIfNeeded(currentLocation: location)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If already founded show message else add it to guesses words
        checkWordIsFoundNowOrAlreadyFounded()
        // Remove drawn line
        resetSwipeLinePath()
        // Reset letter nodes to original color and scale
        resetInteractedLetters()
        // Check if level is completed
        runNextLevelIfNeeded()
    }
    
    
}

// MARK: - SKNode Center

extension SKNode {
    public var center: CGPoint {
        // Get the label's frame
        let nodeFrame = self.frame
        // Calculate the center point
        let centerX = nodeFrame.origin.x + (nodeFrame.size.width / 2)
        let centerY = nodeFrame.origin.y + (nodeFrame.size.height / 2)
        // Create a CGPoint for the center
        return CGPoint(x: centerX, y: centerY)
    }
}
