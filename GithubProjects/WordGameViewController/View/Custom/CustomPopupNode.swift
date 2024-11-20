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
        
        // Popup size
        let popupSize = CGSize(width: 300, height: 220)
        
        // Background
        let background = SKShapeNode(rectOf: popupSize, cornerRadius: 20)
        background.fillColor = UIColor.black.withAlphaComponent(0.9) // Semi-opaque black
        background.strokeColor = .clear
        addChild(background)
        
        // Title Label
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = title
        titleLabel.fontSize = 24
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: popupSize.height / 2 - 50)
        addChild(titleLabel)
        
        // Message Label (Multiline)
        let messageLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        messageLabel.text = message
        messageLabel.fontSize = 18
        messageLabel.fontColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.verticalAlignmentMode = .center
        messageLabel.preferredMaxLayoutWidth = popupSize.width - 40
        messageLabel.position = CGPoint(x: 0, y: popupSize.height / 2 - 110)
        addChild(messageLabel)
        
        // Button
        let button = SKShapeNode(rectOf: CGSize(width: 150, height: 50), cornerRadius: 10)
        button.fillColor = .blue
        button.strokeColor = .clear
        button.position = CGPoint(x: 0, y: popupSize.height / 2 - 165)
        button.name = "button"
        addChild(button)
        
        // Button Label
        let buttonLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        buttonLabel.text = buttonTitle
        buttonLabel.fontSize = 20
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
    
    // Handle touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let button = self.childNode(withName: "button"), button.contains(location) {
            if let action = button.userData?["action"] as? () -> Void {
                action()
            }
            self.removeFromParent() // Remove popup after action
        }
    }
}
