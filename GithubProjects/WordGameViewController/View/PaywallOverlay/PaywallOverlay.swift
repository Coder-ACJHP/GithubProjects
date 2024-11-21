//
//  PaywallOverlay.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import Foundation
import SpriteKit

class PaywallOverlay: SKNode {
    
    init(size: CGSize) {
        super.init()
        
        // Set up the semi-transparent background
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: size)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // Ensure it's above other nodes
        background.name = "overlayBackground"
        addChild(background)
        
        // Add the container for the paywall UI
        let container = SKShapeNode(rectOf: CGSize(width: 300, height: 400), cornerRadius: 12)
        container.fillColor = .white
        container.strokeColor = .clear
        container.position = CGPoint(x: size.width / 2, y: size.height / 2)
        container.zPosition = 1 // Above the background
        addChild(container)
        
        // Add a title label
        let titleLabel = SKLabelNode(text: "Unlock Premium!")
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = 20
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: 0, y: 120) // Relative to container
        container.addChild(titleLabel)
        
        // Add a close button
        let closeButton = SKLabelNode(text: "Close")
        closeButton.name = "closeButton"
        closeButton.fontName = "Helvetica"
        closeButton.fontSize = 18
        closeButton.fontColor = .red
        closeButton.position = CGPoint(x: 0, y: -160) // Relative to container
        container.addChild(closeButton)
        
        // Button Action
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = self.atPoint(location)
        
        // Handle close button tap
        if tappedNode.name == "closeButton" {
            run(SKAction.fadeOut(withDuration: 0.3)) {
                self.removeAllActions()
                self.removeAllChildren()
                self.removeFromParent()
            }
        }
    }
}

