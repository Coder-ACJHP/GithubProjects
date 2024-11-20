//
//  CustomLabelNode.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import SpriteKit

class CustomLabelNode: SKNode {
    
    private let backgroundNode: SKShapeNode
    private var cornerRadius: CGFloat = 10
    public let labelNode: SKLabelNode
    
    public var text: String? {
        didSet {
            labelNode.text = text
        }
    }
    public var fontSize: CGFloat = 30 {
        didSet {
            labelNode.fontSize = fontSize
        }
    }
    public var fontColor: UIColor = .white {
        didSet {
            labelNode.fontColor = fontColor
        }
    }
    public var fontName: String? = "AvenirNext-Regular" {
        didSet {
            labelNode.fontName = fontName
        }
    }
    public var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center {
        didSet {
            labelNode.horizontalAlignmentMode = horizontalAlignmentMode
        }
    }
    public var verticalAlignmentMode: SKLabelVerticalAlignmentMode = .center {
        didSet {
            labelNode.verticalAlignmentMode = verticalAlignmentMode
        }
    }
    public var backgroundColor: UIColor = .darkGray {
        didSet {
            backgroundNode.fillColor = backgroundColor
        }
    }
    public var borderColor: UIColor = .clear {
        didSet {
            backgroundNode.strokeColor = borderColor
        }
    }
    public var borderLineWidth: CGFloat = 2 {
        didSet {
            backgroundNode.lineWidth = borderLineWidth
        }
    }

    init(size: CGSize? = CGSize(width: 40, height: 40),
         text: String,
         fontSize: CGFloat = 30,
         fontColor: UIColor = .white,
         fontName: String? = "AvenirNext-Regular",
         backgroundColor: UIColor = .darkGray,
         borderColor: UIColor = .clear,
         borderLineWidth: CGFloat = 2,
         cornerRadius: CGFloat = 10,
         position: CGPoint = .zero,
         horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center,
         verticalAlignmentMode: SKLabelVerticalAlignmentMode = .center) {
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderLineWidth = borderLineWidth
        self.cornerRadius = cornerRadius
        self.horizontalAlignmentMode = horizontalAlignmentMode
        self.verticalAlignmentMode = verticalAlignmentMode
        
        // Initialize the label node
        labelNode = SKLabelNode(text: self.text)
        labelNode.fontSize = self.fontSize
        labelNode.fontColor = self.fontColor
        labelNode.fontName = self.fontName
        labelNode.verticalAlignmentMode = self.verticalAlignmentMode

        // Initialize the background node with placeholder size
        let initialWidth = size?.width ??  40
        let initialHeight = size?.height ?? 40
        backgroundNode = SKShapeNode(
            path: CGPath(
                roundedRect: CGRect(
                    x: -initialWidth / 2,
                    y: -initialHeight / 2,
                    width: initialWidth,
                    height: initialHeight
                ),
                cornerWidth: cornerRadius,
                cornerHeight: cornerRadius,
                transform: nil
            )
        )
        backgroundNode.fillColor = backgroundColor
        backgroundNode.strokeColor = borderColor
        backgroundNode.lineWidth = borderColor == .clear ? 0 : 2

        super.init()

        // Add nodes to the parent
        addChild(backgroundNode)
        addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
