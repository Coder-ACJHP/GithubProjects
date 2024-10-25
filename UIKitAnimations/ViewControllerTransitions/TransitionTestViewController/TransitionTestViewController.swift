//
//  TransitionTestViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

class TransitionTestViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    enum TransitionType {
        case none, barSwipe, ripple, copyMachine, mod, flash, swipe
    }
    
    public let backgroundImageView: UIImageView = {
        let image = UIImage(resource: .background)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let buttonsAction: Selector = {
        return #selector(startButtonPressed)
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start transition", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .black
        btn.addTarget(self, action: buttonsAction, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var transitionDuration: CGFloat = 1.0
    private var transitionType: TransitionType = .none
    
    init(title: String, transitionEffect: TransitionType) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.transitionType = transitionEffect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureBackgroundView()
        configureStartButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureBackgroundView() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureStartButtonView() {
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        startButton.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: view.bounds.width - 40, height: 50)), cornerRadius: startButton.layer.cornerRadius).cgPath
        startButton.layer.shadowColor = UIColor.gray.cgColor
        startButton.layer.shadowOffset = .zero
        startButton.layer.shadowOpacity = 0.7
        startButton.layer.shadowRadius = 15
        startButton.layer.rasterizationScale = UIScreen.main.scale
        startButton.layer.allowsEdgeAntialiasing = true
        startButton.layer.shouldRasterize = true
    }
    
    @objc
    private func startButtonPressed() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let nextVC = TransitionDestinationViewController(title: "Destination VC")
            nextVC.transitioningDelegate = self
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true, completion: nil)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch transitionType {
        case .none: return nil
        case .barSwipe:
            return BarsSwipeEffectTransition(duration: transitionDuration)
        case .ripple:
            return RippleEffectTransition(duration: transitionDuration)
        case .copyMachine:
            return CopyMachineEffectTransition(duration: transitionDuration)
        case .mod:
            return ModEffectTransition(duration: transitionDuration)
        case .flash:
            return FlashEffectTransition(duration: transitionDuration)
        case .swipe:
            return SwipeEffectTransition(duration: transitionDuration, direction: .rightToleft)
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch transitionType {
        case .none: return nil
        case .barSwipe:
            return BarsSwipeEffectTransition(duration: transitionDuration)
        case .ripple:
            return RippleEffectTransition(duration: transitionDuration)
        case .copyMachine:
            return CopyMachineEffectTransition(duration: transitionDuration)
        case .mod:
            return ModEffectTransition(duration: transitionDuration)
        case .flash:
            return FlashEffectTransition(duration: transitionDuration)
        case .swipe:
            return SwipeEffectTransition(duration: transitionDuration, direction: .leftToRight)
        }
    }
}
