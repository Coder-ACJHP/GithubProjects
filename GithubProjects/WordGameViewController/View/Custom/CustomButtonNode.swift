//
//  CustomButtonNode.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 20.11.2024.
//

import UIKit
import SpriteKit

class CustomButtonNode: SKSpriteNode {
    var touchUpInside: (() -> Void)?

    init(title: String, color: UIColor) {
        super.init(texture: nil, color: color, size: CGSize(width: 200, height: 50))

        let label = SKLabelNode(text: title)
        label.fontSize = 20
        label.fontName = "AvenirNext-Bold"
        label.fontColor = .white
        label.position = .zero
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.preferredMaxLayoutWidth = self.size.width
        addChild(label)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.scale(to: 0.9, duration: 0.1))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.scale(to: 1.0, duration: 0.1)) {
            self.touchUpInside?()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.scale(to: 1.0, duration: 0.1))
    }
}
