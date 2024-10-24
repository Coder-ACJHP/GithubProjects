//
//  BaseViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit

class BaseViewController: UIViewController, UINavigationBarDelegate {
    
    private let navbar = UINavigationBar()
    private let backButton = UIButton(type: .system)
    
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
    
    @objc
    private func handleBackButtonPress() {
        dismiss(animated: true)
    }
    
    // Must be confirmed for standalone navigation bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
