//
//  WordGameViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 19.11.2024.
//

import Foundation
import UIKit
import UIKit
import SpriteKit

class WordGameViewController: UIViewController {
    
    public var skView: SKView!
    
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
        
        skView = SKView(frame: view.bounds) // Ensure the SKView has the correct frame
        view.addSubview(skView)
        // Setup navigation manager with main SKView
        let navigationManager = NavigationManager.shared
        navigationManager.skView = skView
        navigationManager.navigateToMenuScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - UI Overrides

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var prefersHomeIndicatorAutoHidden: Bool { true }
}
