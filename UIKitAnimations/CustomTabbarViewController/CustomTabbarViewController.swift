//
//  CustomTabbarViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 25.10.2024.
//

import UIKit

class CustomTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let animatedTabbar = AnimatedTabbar()
    
    private lazy var vc1: UIViewController = {
        let vc = BaseViewController()
        vc.tabBarItem = .init(title: "Home", image: UIImage(resource: .houseFill), tag: 0)
        vc.view.backgroundColor = .white
        vc.title = "Home"
        vc.tintColor = .black
        return vc
    }()
    
    public lazy var vc2: UIViewController = {
        let vc = BaseViewController()
        vc.tabBarItem = .init(title: "Map", image: UIImage(resource: .mapFill), tag: 1)
        vc.view.backgroundColor = .white
        vc.title = "Map"
        vc.tintColor = .black
        return vc
    }()
    
    private lazy var vc3: UIViewController = {
        let vc = BaseViewController()
        vc.tabBarItem = .init(title: "Settings", image: UIImage(resource: .gear), tag: 2)
        vc.view.backgroundColor = .white
        vc.title = "Settings"
        vc.tintColor = .black
        return vc
    }()

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        view.backgroundColor = .appLightGray
        viewControllers = [vc1, vc2, vc3]
        tabBar.isTranslucent = true
        tabBar.isHidden = true
        
        configureCustomTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
        if let selectedItem = tabBar.items?[selectedIndex] {
            animatedTabbar.selectedItem = selectedItem
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                animatedTabbar.updatePathFor(item: selectedItem)
            }
        }
    }
    
    private func configureCustomTabbar() {
        view.addSubview(animatedTabbar)
        animatedTabbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatedTabbar.topAnchor.constraint(equalTo: tabBar.topAnchor),
            animatedTabbar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            animatedTabbar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            animatedTabbar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
        ])
        animatedTabbar.delegate = self
        animatedTabbar.tintColor = .darkGray
        
        let normalTitleAttrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor : UIColor.lightGray
        ]
        
        let selectedTitleAttrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor : UIColor.darkGray
        ]
        
        if let items = tabBar.items {
            animatedTabbar.items = items
            
            for index in 0 ..< items.count {
                let item = items[index]
                item.setTitleTextAttributes(normalTitleAttrs, for: .normal)
                item.setTitleTextAttributes(selectedTitleAttrs, for: .selected)
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animatedTabbar.updatePathFor(item: item)
    }
}
