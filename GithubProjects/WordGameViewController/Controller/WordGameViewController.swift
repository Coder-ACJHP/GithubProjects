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
    
    private var skView: SKView!
    private var notificationCenter = NotificationCenter.default
    
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
        
        addNotifcationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        removeNotificationObservers()
    }
    
    private func addNotifcationObservers() {
        let action = #selector(handleNotification(_:))
        notificationCenter.addObserver(self, selector: action, name: .needsToShowDictionary, object: nil)
    }
    
    private func removeNotificationObservers() {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    private func handleNotification(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let name = notification.name
        if name == NSNotification.Name.needsToShowDictionary,
           let word = userInfo["word"] as? String {
            
            if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
                var childVC = UIReferenceLibraryViewController(term: word)
                present(childVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UI Overrides

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var prefersHomeIndicatorAutoHidden: Bool { true }
}
