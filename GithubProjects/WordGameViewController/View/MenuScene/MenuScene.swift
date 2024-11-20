//
//  MenuScene.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    private let swipeGameButton = CustomButtonNode(title: "Swipe to suggest", color: .systemBlue)
    private let fillGameButton = CustomButtonNode(title: "Fill in the blank", color: .systemOrange)
    private let dismissButton = CustomButtonNode(title: "Dismiss", color: .systemRed)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupButtons()
        addButtonAnimations()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        // Remove all child nodes
        self.removeAllChildren()
        // Remove all actions
        self.removeAllActions()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "gameBackgroundImage") // Replace with your background image name
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        let scale = size.height / background.size.height
        background.size = CGSize(width: background.size.width * scale, height: background.size.height * scale)
        background.zPosition = -1 // Send to back
        addChild(background)
        
        let dimView = SKSpriteNode(color: .black.withAlphaComponent(0.6), size: size)
        dimView.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dimView.zPosition = -1 // Send to back
        addChild(dimView)
    }
    
    func setupButtons() {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        
        swipeGameButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        fillGameButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        dismissButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        
        swipeGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + 60)
        fillGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dismissButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        
        addChild(swipeGameButton)
        addChild(fillGameButton)
        addChild(dismissButton)
        
        // Add touch event handlers
        swipeGameButton.touchUpInside = {
            NavigationManager.shared.navigateToSwipeGameScene()
        }
        
        fillGameButton.touchUpInside = {
            NavigationManager.shared.navigateToFillGameScene()
        }
        
        dismissButton.touchUpInside = { [weak self] in
            guard let self else { return }
            dismissGame()
        }
    }
    
    func addButtonAnimations() {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let touchDown = SKAction.sequence([scaleUp, scaleDown])
        
        swipeGameButton.run(touchDown)
        fillGameButton.run(touchDown)
        dismissButton.run(touchDown)
    }
    
    func dismissGame() {
        view?.window?.rootViewController?.dismiss(animated: true)
    }
}
