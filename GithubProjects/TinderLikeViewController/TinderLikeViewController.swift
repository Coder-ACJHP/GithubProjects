//
//  TinderLikeViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 28.10.2024.
//

import Foundation
import UIKit

class TinderLikeViewController: BaseViewController {

    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private let label: UILabel = {
       let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.text = "Swipe \n⇜ left or right ⇝"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var initialCardCenter: CGPoint!
    private lazy var divisor: CGFloat = {
        return (view.frame.width / 2) / 0.70
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
        view.backgroundColor = .appLightGray
        configureNavigationBar()
        configureLabelView()
        configureCardView()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureLabelView() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
        ])
    }
    
    private func configureCardView() {
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: view.bounds.width - 80),
            cardView.heightAnchor.constraint(equalToConstant: view.bounds.height - 350),
        ])
        cardView.layoutIfNeeded()
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor   = UIColor.gray.cgColor
        cardView.layer.shadowRadius  = 7
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = .zero
        cardView.layer.rasterizationScale = UIScreen.main.scale
        cardView.layer.shouldRasterize = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        guard let cardView = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began:
            initialCardCenter = cardView.center
        case .changed:
            cardView.center = CGPoint(x: initialCardCenter.x + translation.x, y: initialCardCenter.y)
            let xFactor = cardView.center.x - view.center.x
            let radius: CGFloat = xFactor / divisor
            cardView.transform = CGAffineTransform(rotationAngle: radius)
            let cardSwipeDirection = abs(xFactor) / view.center.x
            let opacity: CGFloat = 1.0 - cardSwipeDirection
            cardView.alpha = opacity
        case .ended:
            UIView.animate(
                withDuration: 0.75,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 4.0,
                options: [],
                animations: {
                    cardView.center = self.view.center
                    cardView.alpha = 1.0
                    cardView.transform = .identity
                },
                completion: nil
            )
        default: break
        }
    }

}
