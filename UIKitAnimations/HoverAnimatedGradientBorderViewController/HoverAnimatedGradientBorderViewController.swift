//
//  HoverAnimatedGradientBorderViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 4.11.2024.
//

import UIKit

class HoverAnimatedGradientBorderViewController: BaseViewController {

    private let animatingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let borderWidth: CGFloat = 10.0
    private let cornerRadius: CGFloat = 10.0
    private let animationDuration: CGFloat = 1.0
    private var fromColors: Array<CGColor> = [
        UIColor.red.cgColor, UIColor.green.cgColor, UIColor.gray.cgColor, UIColor.blue.cgColor
    ]
    private var toColors: Array<CGColor> = []
    private let gradientLayer = CAGradientLayer()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        toColors = fromColors.reversed()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray
        configureAnimatedView()
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
        animatingView.layer.shadowRadius = 20.0
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
        
        // Gradient layer
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.colors = fromColors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = .init(x: 1.0, y: 1.0)
        animatingView.layer.addSublayer(gradientLayer)
        animatingView.layoutIfNeeded()
        gradientLayer.frame = animatingView.bounds
        
        // Color animation
        animateColors()
        
        // Add shape layer to fill center of animatedView
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: cornerRadius).cgPath
        maskLayer.fillColor = nil
        maskLayer.strokeColor = UIColor.purple.cgColor
        maskLayer.lineWidth = borderWidth
        
        gradientLayer.mask = maskLayer
    }
    
    private func animateColors() {
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = fromColors
        colorAnimation.toValue = toColors
        colorAnimation.duration = animationDuration
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true
        colorAnimation.fillMode = .forwards
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(colorAnimation, forKey: "borderColors")
    }
}
