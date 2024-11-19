//
//  Parallax3DCardEffectViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 4.11.2024.
//

import UIKit

class Parallax3DCardEffectViewController: BaseViewController {

    private let animatingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let perspective: CGFloat = -1.0 / 500
    private let cornerRadius: CGFloat = 10.0
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray
        configureAnimatedView()
        setupPanGesture()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }

    private func configureAnimatedView() {
        
        let width = view.bounds.width * 0.6
        let cardFrame = CGRect(origin: .zero, size: CGSize(width: width, height: width * 1.2))
        animatingView.layer.cornerRadius = cornerRadius
        animatingView.layer.shadowPath = UIBezierPath(roundedRect: cardFrame, cornerRadius: cornerRadius).cgPath
        animatingView.layer.shadowColor = UIColor.gray.cgColor
        animatingView.layer.shadowOpacity = 1.0
        animatingView.layer.shadowRadius = 25.0
        animatingView.layer.shadowOffset = .zero
        animatingView.layer.shouldRasterize = true
        animatingView.layer.rasterizationScale = UIScreen.main.scale
        animatingView.layer.allowsEdgeAntialiasing = true
        view.addSubview(animatingView)
        animatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatingView.widthAnchor.constraint(equalToConstant: cardFrame.width),
            animatingView.heightAnchor.constraint(equalToConstant: cardFrame.height),
            animatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Optional
        let image = UIImage(resource: .background)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = animatingView.layer.cornerRadius
        imageView.layer.masksToBounds = true
        animatingView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: animatingView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: animatingView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: animatingView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: animatingView.trailingAnchor)
        ])
        
        // Apply perspective transform
        var transform = CATransform3DIdentity
        transform.m34 = perspective
        animatingView.layer.transform = transform
    }
    
    private func setupPanGesture() {
        let action = #selector(handlePan(_:))
        let panGesture = UIPanGestureRecognizer(target: self, action: action)
        animatingView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: animatingView.superview)
        let xOffset = translation.x / 20
        let yOffset = translation.y / 20
        
        var transform = CATransform3DIdentity
        transform.m34 = perspective
        // Transform vertically
        transform = CATransform3DRotate(transform, offsetToAngle(isVertical: true, xOffset: xOffset, yOffset: yOffset), -1, 0, 0)
        // Transform horizontally by concatnating veritcal transform
        transform = CATransform3DRotate(transform, offsetToAngle(isVertical: false, xOffset: xOffset, yOffset: yOffset), 0, 1, 0)
        animatingView.layer.transform = transform
        
        if gesture.state == .ended {
            UIView.animate(
                withDuration: 0.3,
                delay: .zero,
                usingSpringWithDamping: 0.35,
                initialSpringVelocity: 1.0,
                options: [.allowUserInteraction],
                animations: {
                    self.animatingView.layer.transform = CATransform3DIdentity
                },
                completion: nil
            )
        }
    }
    
    private func offsetToAngle(isVertical: Bool = false, xOffset: CGFloat, yOffset: CGFloat) -> CGFloat {
        let progress = (isVertical ? yOffset : xOffset) / (isVertical ? view.bounds.height : view.bounds.width)
        return progress * 10.0
    }
}
