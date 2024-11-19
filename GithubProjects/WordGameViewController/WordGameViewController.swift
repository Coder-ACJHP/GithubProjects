//
//  WordGameViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import UIKit
import SpriteKit

class WordGameViewController: UIViewController {
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray

        let skView = SKView(frame: view.bounds) // Ensure the SKView has the correct frame
        view.addSubview(skView)
        
        let sceneSize = CGSize(width: skView.bounds.width, height: skView.bounds.height)
        let scene = WordGameScene(size: sceneSize) // Initialize the scene with the correct size
        scene.scaleMode = .resizeFill // Ensures it fills the screen dynamically
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
