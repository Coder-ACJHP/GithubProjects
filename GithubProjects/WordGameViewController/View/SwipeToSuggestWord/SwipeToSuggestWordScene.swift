//
//  SwipeToSuggestWordScene.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import UIKit
import SpriteKit

class SwipeToSuggestWordScene: SKScene {
    
    // UI Elements
    private var wordSlots: [CustomLabelNode] = [] // Slots for the target words
    private var letterNodes: [CustomLabelNode] = [] // Letters at the bottom
    private var currentLetterPath: [CustomLabelNode] = [] // Tracks the user's current swipe path
    private var closeButton: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var diamondButton: SKSpriteNode!
    private var diamondLabel: SKLabelNode!
    private var dictionaryButton: SKSpriteNode!
    private var extraWordsButton: SKSpriteNode!
    private var shuffleButton: SKSpriteNode!
    private var hintButton: SKSpriteNode!
    
    private var lastTouchLocation: CGPoint?
    private var currentLinePath: CGMutablePath!
    private var swipeLine = SKShapeNode()
    
    // Game State
    private var targetWords: [String] = [] // Words for the current level
    private var guessedWords: Set<String> = [] // Words guessed by the player
    private var extraWords: Set<String> = [] // Words guessed by the player but level doesnt contains it
    private var guessedExtraWords: Set<String> = [] // Words guessed by the player but level doesnt contains it
    private var letterPool: String = "" // Pool of letters to display
    private var isWordFound: Bool = false // Used for animation
    private var hintedLettersList: Array<String> = []
    // Level Data
    private var currentLevel: Int = 1 {
        didSet { minRequiredDiamonds = currentLevel }
    }
    // Diamond count for each hint changes based on levels
    private var minRequiredDiamonds: Int = .zero
    private var diamonds: Int = .zero
    private let levels = SwipeGameLevelManager.shared.getLevels()
    private let rowCount = 6
    private let columnCount = 7
    // Game state update variables
    private let notificationCenter = NotificationCenter.default
        
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        loadLastGameData()
        
        // Observe Notifications for saving game data
        notificationCenter.addObserver(
            self,
            selector: #selector(updateGameStateInDatabase),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(updateGameStateInDatabase),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        // Cleanup Observers
        notificationCenter.removeObserver(self)
        // Remove all child nodes
        self.removeAllChildren()
        // Remove all actions
        self.removeAllActions()
    }
    
    deinit {
        
    }

    @objc func updateGameStateInDatabase() {
        saveGameData()
    }
    
    func loadLevel(_ level: Int, fromDB: Bool = false) {
        guard level > 0 && level - 1 < levels.count else {
            showPopup(
                withTitle: "Error",
                message: "Invalid level. Please restart the game.",
                buttonTitle: "Dismiss",
                completion: { [weak self] in self?.dismissGameScene() }
            )
            return
        }
        
        let levelData = levels[level - 1]
        guard !levelData.targetWords.isEmpty else {
            showPopup(
                withTitle: "No Words",
                message: "This level has no target words. Skipping.",
                buttonTitle: "Next Level",
                completion: { [weak self] in self?.loadLevel(level + 1) }
            )
            return
        }
        
        // If loading from the scratch release all old data
        if !fromDB {
            extraWords = []
            guessedExtraWords = []
            guessedWords = []
            hintedLettersList = []
            targetWords = []
            letterPool = ""
            wordSlots.removeAll()
            letterNodes.removeAll()
            currentLetterPath.removeAll()
        }
        
        targetWords = levelData.targetWords
        extraWords = Set(levelData.extraWords)
        letterPool = levelData.letters
        
        configureDiamondLabel()
        configureTitleLabel()
        setupCloseButton()
        setupWordSlots()
        setupLetterNodes()
        configureSwipeLine()
        setupHintButton()
        setupShuffleButton()
        setupDictionaryButton()
        setupExtraWordsButton()
    }
    
    // MARK: - Configure UI
    
    private func configureSwipeLine() {
        swipeLine.strokeColor = .white
        swipeLine.lineWidth = 8
        swipeLine.lineCap = .round
        swipeLine.lineJoin = .round
        swipeLine.name = "swipeLine"
        
        currentLinePath = CGMutablePath()
        swipeLine.path = currentLinePath
        
        addChild(swipeLine)
    }
    
    private func configureDiamondLabel() {
        let texture = SKTexture(image: UIImage(resource: .suitDiamondFill))
        diamondButton = SKSpriteNode(texture: texture)
        diamondButton.name = "diamondButton"
        diamondButton.position = CGPoint(x: 30, y: size.height - 55)
        // Add the diamond button to the scene
        addChild(diamondButton)
        
        diamondLabel = SKLabelNode(text: "\(diamonds)")
        diamondLabel.fontName = "AvenirNext-Bold"
        diamondLabel.fontSize = 20
        diamondLabel.fontColor = .white
        diamondLabel.verticalAlignmentMode = .center
        diamondLabel.position = CGPoint(x: 20, y: 0)
        diamondLabel.isUserInteractionEnabled = false
        // Add the label as child
        diamondButton.addChild(diamondLabel)
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
    
    private func configureTitleLabel() {
        titleLabel = SKLabelNode(text: "Level \(currentLevel)")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 20
        titleLabel.fontColor = .white
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 55)
        // Add the close button to the scene
        addChild(titleLabel)
    }
    
    private func setupShuffleButton() {
        let texture = SKTexture(image: UIImage(resource: .shuffle))
        shuffleButton = SKSpriteNode(texture: texture)
        shuffleButton.position = CGPoint(x: size.width - 40, y: 40)
        shuffleButton.name = "shuffleButton"
        shuffleButton.setScale(0.7)
        
        // Add the shuffle button to the scene
        addChild(shuffleButton)
    }
    
    private func setupDictionaryButton() {
        
        let topMargin: CGFloat = size.height - 110 // Position the word slots near the top
        let spacing: CGFloat = 10 // Spacing between squares
        let availableWidth = self.size.width - (spacing * 9)
        let squareSize: CGFloat = availableWidth / CGFloat(columnCount) // Size of each rounded square
        let wordSpacing = squareSize + spacing // Spacing between words
        let posiX = spacing * 4
        let posiY = (topMargin - CGFloat(rowCount) * wordSpacing) - 10
            
            
        let texture = SKTexture(image: UIImage(resource: .dictionary))
        dictionaryButton = SKSpriteNode(texture: texture)
        dictionaryButton.position = CGPoint(x: posiX, y: posiY)
        dictionaryButton.name = "dictionaryButton"
        
        // Add the shuffle button to the scene
        addChild(dictionaryButton)
    }    
    
    private func setupExtraWordsButton() {
        let posiX = size.width - 30
        let posiY = dictionaryButton.position.y
            
        let texture = SKTexture(image: UIImage(resource: .list))
        extraWordsButton = SKSpriteNode(texture: texture)
        extraWordsButton.position = CGPoint(x: posiX, y: posiY)
        extraWordsButton.name = "notIncludedButton"
        extraWordsButton.setScale(0.9)
        
        // Add the shuffle button to the scene
        addChild(extraWordsButton)
    }
    
    private func setupHintButton() {
        let texture = SKTexture(image: UIImage(resource: .hint))
        hintButton = SKSpriteNode(texture: texture)
        hintButton.position = CGPoint(x: 40, y: 40)
        hintButton.name = "hintButton"
        hintButton.setScale(0.7)
        
        // Add the shuffle button to the scene
        addChild(hintButton)
        
        shakeHintButtonForever()
    }
    
    private func setupWordSlots() {
        let topMargin: CGFloat = size.height - 110 // Position the word slots near the top
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
                wordSlots.append(label)
            }
        }
    }
    
    private func setupLetterNodes() {
        let availableWidth = size.width * 0.7 // Subtract left (20px) and right (20px) padding
        let radius: CGFloat = availableWidth / 3 // Maximum radius based on available width
        let angleStep = CGFloat.pi * 2 / CGFloat(letterPool.count) // Angle between letters for full circle
        let startAngle = -CGFloat.pi / 2 // Start at the top of the circle (upside down)
        let squareSize: CGFloat = 50 // Size of each rounded square
        let shuffledLetters = letterPool.shuffled()
        
        // Calculate the center point
        let bottomCenter = CGPoint(x: size.width / 2, y: size.height * 0.25) // Center of the circle
        
        for (index, char) in shuffledLetters.enumerated() {
            let angle = startAngle + CGFloat(index) * angleStep
            let x = bottomCenter.x + radius * cos(angle)
            let y = bottomCenter.y + radius * sin(angle)
            let position = CGPoint(x: x, y: y)
            
            let letterNode = CustomLabelNode(
                size: CGSize(width: squareSize, height: squareSize),
                text: String(char),
                fontSize: 35,
                fontColor: .white,
                fontName: "AvenirNext-Bold",
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
    
    private func showShortMessage(text: String) {
        // Create the label for the message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 1.5
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 10
        shadow.shadowOffset = .zero
        let attrs: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .font : UIFont(name: "AvenirNext-Regular", size: 18) ?? .systemFont(ofSize: 18),
            .paragraphStyle : paragraphStyle,
            .shadow : shadow
        ]
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(attrs, range: NSRange(location: 0, length: text.count))
        let messageLabel = SKLabelNode(attributedText: attributedString)
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.verticalAlignmentMode = .center
        messageLabel.numberOfLines = 0
        messageLabel.preferredMaxLayoutWidth = self.size.width * 0.7
        messageLabel.alpha = 0
        addChild(messageLabel)
        
        // Animate the message label to fade in and then out
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let wait = SKAction.wait(forDuration: 0.6)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
        
        // Run the sequence and then remove the message label
        messageLabel.run(sequence) {
            messageLabel.removeFromParent() // Remove the label after the animation
        }
    }
    
    private func shakeHintButtonForever() {
        // Define keyframes for the rotation angles
        let keyframeRotations: [CGFloat] = [-0.15, 0.15, -0.07, 0.07, -0.05, 0.05, 0] // Rotation angles in radians
        let keyframeDurations: [TimeInterval] = [0.15, 0.15, 0.1, 0.1, 0.1, 0.1, 0.2] // Durations for each keyframe
        
        // Ensure keyframeRotations and keyframeDurations are of the same length
        guard keyframeRotations.count == keyframeDurations.count else {
            print("Keyframes mismatch: Check rotations and durations arrays")
            return
        }
        
        // Build the keyframe actions
        var actions: [SKAction] = []
        for (index, rotation) in keyframeRotations.enumerated() {
            let duration = keyframeDurations[index]
            let action = SKAction.rotate(toAngle: rotation, duration: duration, shortestUnitArc: true)
            actions.append(action)
        }
        
        // Create the keyframe animation
        let waitAction = SKAction.wait(forDuration: 1.0)
        actions.append(waitAction)
        let keyframeSequence = SKAction.sequence(actions)
        let repeatForever = SKAction.repeatForever(keyframeSequence)
        hintButton.run(repeatForever)
    }
    
    func showDictionary(for word: String) {
        let userInfo = ["word": word]
        NotificationCenter.default.post(name: .needsToShowDictionary, object: nil, userInfo: userInfo)
    }
    
    func showDictionaryPopup() {
        let popup = CustomDictionaryPopupNode(
            title: "Guessed Words",
            message: "Tap on word to see meainings in the dictionary",
            guessedWords: guessedWords
        ) { [weak self] didTapOnWord in
            guard let self else { return }
            showDictionary(for: didTapOnWord)
        }
        popup.zPosition = 100
        addChild(popup)
        popup.alpha = .zero
        // Animate
        popup.run(SKAction.fadeIn(withDuration: 0.3))
    }
    
    func showExtraWordsListPopup() {
        let popup = CustomDictionaryPopupNode(
            title: "Extra Words",
            message: "These are real words you guessed, but they’re not part of this level.",
            guessedWords: guessedExtraWords
        ) { [weak self] didTapOnWord in
            guard let self else { return }
            showDictionary(for: didTapOnWord)
        }
        popup.zPosition = 100
        addChild(popup)
        popup.alpha = .zero
        // Animate
        popup.run(SKAction.fadeIn(withDuration: 0.3))
    }
    
    func showPopup(withTitle title: String, message: String, buttonTitle: String, completion: @escaping () -> Void) {
        let popup = CustomPopupNode(
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            buttonAction: { completion() }
        )
        popup.zPosition = 100
        addChild(popup)
        popup.alpha = .zero
        // Animate
        popup.run(SKAction.fadeIn(withDuration: 0.3))
    }
    
    private func dismissGameScene() {
        NavigationManager.shared.returnToMenuScene()
    }
    
    private func showPaywallScene() {
        let overlay = PaywallOverlay(size: self.size)
        overlay.zPosition = 10 // Ensure it appears on top of other nodes
        overlay.name = "paywallOverlay"
        addChild(overlay)
        overlay.alpha = .zero
        overlay.run(SKAction.fadeIn(withDuration: 0.3))
    }
    
    private func shuffleLetters() {
        // Step 1: Shuffle the letter nodes array
        let shuffledNodes = letterNodes.shuffled()
        // Step 2: Define circular layout parameters
        let availableWidth = size.width * 0.7 // Subtract left (20px) and right (20px) padding
        let radius: CGFloat = availableWidth / 3 // Maximum radius based on available width
        let angleStep = CGFloat.pi * 2 / CGFloat(letterPool.count) // Angle between letters for full circle
        let startAngle = -CGFloat.pi / 2 // Start at the top of the circle (upside down)
        // Calculate the center of the circle
        let bottomCenter = CGPoint(x: size.width / 2, y: size.height * 0.25) // Center of the circle
        // Step 3: Calculate new positions and animate
        for (index, node) in shuffledNodes.enumerated() {
            // Calculate the target angle and position
            let targetAngle = startAngle + CGFloat(index) * angleStep
            let newPosition = CGPoint(
                x: bottomCenter.x + radius * cos(targetAngle),
                y: bottomCenter.y + radius * sin(targetAngle)
            )
            // Create a circular rotation path animation for two full revolutions
            let rotationPath = UIBezierPath()
            let currentAngle = atan2(node.position.y - bottomCenter.y, node.position.x - bottomCenter.x)
            rotationPath.addArc(
                withCenter: bottomCenter,
                radius: radius,
                startAngle: currentAngle,
                endAngle: targetAngle + (CGFloat.pi * 4), // Two full rotations
                clockwise: false
            )
            // SKAction to follow the circular path
            let followPathAction = SKAction.follow(rotationPath.cgPath, asOffset: false, orientToPath: false, duration: 1.0)
            // SKAction to ensure the node ends at the exact target position
            let moveToNewPositionAction = SKAction.move(to: newPosition, duration: 0.0)
            // Combine the actions: follow the path, then snap to the final position
            let animation = SKAction.sequence([followPathAction, moveToNewPositionAction])
            animation.timingMode = .easeInEaseOut
            
            // Run the animation
            node.run(animation)
        }
        
        // Step 4: Update the letterNodes array to reflect the new order
        letterNodes = shuffledNodes
    }
    
    private func showHint() {
        guard diamonds >= minRequiredDiamonds else {
            showShortMessage(text: "you don't have enough diamonds, maybe you'll consider buying some.")
            return
        }
        guard let firstEmptySlot = wordSlots.filter({ $0.text == "" }).first,
              let slotName = firstEmptySlot.name
        else {
            print("No empty slot for hint.")
            return
        }
        
        // Validate slotName format using regex
        let regex = try! NSRegularExpression(pattern: "^slotSquare_\\d+_\\d+$")
        let range = NSRange(location: 0, length: slotName.utf16.count)
        guard regex.firstMatch(in: slotName, options: [], range: range) != nil else {
            print("Invalid slotName format: \(slotName)")
            return
        }

        // Parse wordIndex and charIndex from the validated slotName
        let cleanText = slotName.replacingOccurrences(of: "slotSquare_", with: "")
        let components = cleanText.split(separator: "_")
        guard components.count == 2,
              let wordIndex = Int(components[0]),
              let charIndex = Int(components[1]),
              wordIndex < targetWords.count
        else {
            print("Failed to parse indices from slotName: \(slotName)")
            return
        }

        let word = targetWords[wordIndex]
        guard charIndex < word.count else {
            print("Character index out of bounds for word: \(word)")
            return
        }
        
        let char = Array(word)[charIndex]
        hintedLettersList.append(String(char))

        if let label = childNode(withName: slotName) as? CustomLabelNode {
            label.text = String(char) // Set the letter
            label.labelNode.alpha = 0 // Start with alpha 0
            label.labelNode.run(SKAction.fadeIn(withDuration: 0.3)) // Animate fade-in
        }
        
        // Update diamonds and label
        diamonds -= 1
        diamondLabel.text = "\(diamonds)"
        
        // Add created word to guessed word list then check if level finished
        let formedWord = hintedLettersList.joined()
        if targetWords.contains(formedWord), !guessedWords.contains(formedWord) {
            guessedWords.insert(formedWord)
            hintedLettersList = []
            runNextLevelIfNeeded()
        }
    }

    private func saveGameData() {
        let state = SwipeGameState(
            level: currentLevel,
            diamonds: diamonds,
            guessedWords: Array(guessedWords),
            extraWords: Array(extraWords),
            guessedExtraWords: Array(guessedExtraWords),
            hintsUsed: hintedLettersList, // Save the actual list of hinted letters
            targetWords: targetWords
        )
        let encoder = JSONEncoder()
        do {
            let encodedState = try encoder.encode(state)
            let defaults = UserDefaults.standard
            defaults.set(encodedState, forKey: "gameState")
            defaults.synchronize()
        } catch {
            print("Failed to save game state: \(error)")
        }
    }
    
    private func loadLastGameData() {
        let defaults = UserDefaults.standard

        // Check if game state exists in UserDefaults
        if let savedGameState = defaults.data(forKey: "gameState") {
            let decoder = JSONDecoder()
            do {
                let state = try decoder.decode(SwipeGameState.self, from: savedGameState)
                currentLevel = state.level
                diamonds = state.diamonds
                guessedWords = Set(state.guessedWords)
                extraWords = Set(state.extraWords)
                guessedExtraWords = Set(state.guessedExtraWords)
                hintedLettersList = state.hintsUsed // Load the actual list of hinted letters
                targetWords = state.targetWords

                // Load the level layout
                loadLevel(currentLevel, fromDB: true)

                // Populate guessed words into slots
                for guessedWord in guessedWords {
                    fillWordSlot(guessedWord)
                }

                // Handle hinted letters
                for char in hintedLettersList {
                    if let firstEmptySlot = wordSlots.filter({ $0.text == "" }).first {
                        firstEmptySlot.text = char
                    }
                }

            } catch {
                print("Failed to decode game state: \(error)")
                resetGameStateToDefault()
            }
        } else {
            resetGameStateToDefault()
        }
    }
    
    private func resetGameStateToDefault() {
        currentLevel = 1
        // Load the level layout
        guessedWords = []
        hintedLettersList = []
        wordSlots = []
        letterNodes = []
        currentLetterPath = []
        // Clear previous level state
        removeAllChildren()
        loadLevel(currentLevel)
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
        // Create a word from letter path
        let formedWord = currentLetterPath.map { $0.text! }.joined()
        // If the word has already been guessed, show the message
        if guessedWords.contains(formedWord) {
            showShortMessage(text: "You've already guessed that word.")
            
        // If targetWords contains the guessed word and isn't guessed before
        } else if targetWords.contains(formedWord), !guessedWords.contains(formedWord) {
            guessedWords.insert(formedWord)
            fillWordSlot(formedWord)
            isWordFound = true
            
        // If extraWords contains the guessed word and isn't guessed before as extra
        } else if extraWords.contains(formedWord), !guessedExtraWords.contains(formedWord) {
            guessedExtraWords.insert(formedWord)
            showShortMessage(text: "Well done, you got 1 diamond.")
            diamonds += 1
            diamondLabel.text = "\(diamonds)"
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
            showPopup(
                withTitle: "Level Complete!",
                message: "Great job! Get ready for the next level.",
                buttonTitle: "Continue",
                completion: { [weak self] in
                    guard let self else { return }
                    // Remove all child nodes
                    self.removeAllChildren()
                    currentLevel += 1
                    loadLevel(currentLevel)
                }
            )
        }
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        // Reset the flag
        isWordFound = false
        switch touchLocation {
        case let point where closeButton.frame.contains(point):
            saveGameData()
            dismissGameScene()
        case let point where shuffleButton.frame.contains(point):
            shuffleLetters()
        case let point where hintButton.frame.contains(point):
            showHint()
        case let point where diamondButton.frame.contains(point):
            showPaywallScene()
        case let point where dictionaryButton.frame.contains(point):
            showDictionaryPopup()
        case let point where extraWordsButton.frame.contains(point):
            showExtraWordsListPopup()
        default:
            if let touchedNode = atPoint(touchLocation) as? CustomLabelNode,
                letterNodes.contains(touchedNode) {
                currentLinePath = CGMutablePath() // Start a new path
                currentLinePath.move(to: touchedNode.center) // Start the path at the touch location
                lastTouchLocation = touchedNode.center // Set the first touch location
            }
            break
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


