//
//  SKNode+Extension.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 21.11.2024.
//

import SpriteKit

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
