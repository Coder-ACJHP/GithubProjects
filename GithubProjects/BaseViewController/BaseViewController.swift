//
//  BaseViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit

class BaseViewController: UIViewController, UINavigationBarDelegate {
    
    private(set) var navbar = UINavigationBar()
    private let backButton = UIButton(type: .system)
    public var dismmissShouldAnimated = true
    
    override var title: String? {
        didSet {
            navbar.items?.first?.title = title
        }
    }
    
    public var titleAttributes: [NSAttributedString.Key: AnyObject]? {
        didSet {
            navbar.titleTextAttributes = titleAttributes
        }
    }
    
    public var tintColor: UIColor? {
        didSet {
            backButton.setTitleColor(tintColor, for: .normal)
            backButton.tintColor = tintColor
        }
    }
    
    public var hasBackButton: Bool = false {
        didSet {
            backButton.isHidden = !hasBackButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        configureSwipeToBackGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 19, weight: .bold)
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(navbar)
    }
    
    private final func createNavigationBar() {
        view.addSubview(navbar)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let navigationItem = UINavigationItem(title: title ?? "")
        let backButtonImage = UIImage(resource: .chevronLeft).withRenderingMode(.alwaysTemplate)
        backButton.frame = CGRect(origin: .zero, size: CGSize(width: 60, height: 30))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.imageEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        backButton.setTitle("Back", for: .normal)
        let action = #selector(handleBackButtonPress)
        backButton.addTarget(self, action: action, for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
        navbar.setItems([navigationItem], animated: false)
        navbar.delegate = self
    }
    
    private func configureSwipeToBackGesture() {
        let action = #selector(handleSwipe)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: action)
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func prepareForBackTransitionIfNeeded() {
        // Do not compare the style like .push or .back because it'll
        // immediately add a transition to current window insted check it
        // with rawValue initializer
        if modalTransitionStyle == UIModalTransitionStyle(rawValue: -1) {
            modalTransitionStyle = .back
            dismmissShouldAnimated = false
        } else if modalTransitionStyle == UIModalTransitionStyle(rawValue: -2) {
            modalTransitionStyle = .pushToTheBottom
            dismmissShouldAnimated = false
        } else if modalTransitionStyle == UIModalTransitionStyle(rawValue: -3) {
            modalTransitionStyle = .pullFromTheTop
            dismmissShouldAnimated = false
        }
    }
    
    @objc
    private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended { handleBackButtonPress() }
    }
    
    @objc
    private func handleBackButtonPress() {
        prepareForBackTransitionIfNeeded()
        dismiss(animated: dismmissShouldAnimated)
    }
    
    // Must be confirmed for standalone navigation bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
