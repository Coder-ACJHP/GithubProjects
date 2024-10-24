//
//  MainViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit

class MainViewController: BaseViewController {
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let destinationVCList: Array<String> = [
        "Image RippleEffect",
        "Carousel CollectionView",
        "3D Stacked Items",
        "RippleTransition",
        "BarSwipeTransition",
        "CopyMachineTransition",
        "ModTransition",
        "FlashTransition",
        "SwipeTransition"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        configureNavigationBar()
        configureVStackView()
        configureFeatureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "UIKit Animations"
        titleAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
        tintColor = .black
        hasBackButton = false
    }
    
    private func configureVStackView() {
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            vStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        ])
    }
//
    private func configureFeatureButtons() {
        for index in 0 ..< destinationVCList.count {
            let button = UIButton(type: .system)
            button.backgroundColor = .black
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitle(destinationVCList[index], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            vStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func handleButtonPress(_ sender: UIButton) {
        let title = destinationVCList[sender.tag]
        var destinationVC: UIViewController?
        switch title {
        case "Image RippleEffect":
            destinationVC = ImageRippleTransitionViewController(title: title)
        case "Carousel CollectionView":
            destinationVC = CarouselViewController(title: title)
        case "3D Stacked Items":
            destinationVC = StackedItemsViewController(title: title)
        case "RippleTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .ripple)
        case "BarSwipeTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .barSwipe)
        case "CopyMachineTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .copyMachine)
        case "ModTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .mod)
        case "FlashTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .flash)
        case "SwipeTransition":
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .swipe)
        default: break
        }

        guard let destinationVC else { return }
        destinationVC.modalTransitionStyle = .coverVertical
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}
