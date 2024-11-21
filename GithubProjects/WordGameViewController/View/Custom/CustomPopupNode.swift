//
//  CustomPopupNode.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import SpriteKit

class CustomPopupNode: SKNode {
    init(title: String, message: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
        super.init()
        
        // Background
        let screenSize = UIScreen.main.bounds.size
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: screenSize)
        background.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        background.zPosition = -1 // Ensure it's above other nodes
        background.name = "overlayBackground"
        addChild(background)
        
        // Centered container
        let containerNode = SKShapeNode(rectOf: CGSize(width: 300, height: 220), cornerRadius: 12)
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
        
        // Button Action
        isUserInteractionEnabled = true
        button.userData = ["action": buttonAction] as NSMutableDictionary
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
        
        if let buttonNode = self.childNode(withName: "button"), buttonNode.contains(location) {
            animateScaleDown(buttonNode)
        }
    }
    
    // Handle touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let button = self.childNode(withName: "dismissButton_animatable"), button.contains(location) {
            animateScaleUp(button) // Apply press effect
            // Animate removing
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
            self.run(SKAction.sequence([fadeOutAction, SKAction.removeFromParent()])) {
                if let action = button.userData?["action"] as? () -> Void {
                    action()
                }
            }
        }
    }
}
