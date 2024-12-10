//
//  GradientBorderViewController.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 10.12.2024.
//

import UIKit

class GradientBorderViewController: BaseViewController {
    
    private let animatingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let innerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    private let shapeLayer = CAShapeLayer()
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
        configureNavigationBar()
        createGradientBorderEffect()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = updateGradientLayerFrame()
        shapeLayer.path = updateShapeLayerPath()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAnimation()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    func createGradientBorderEffect() {
        // Container view
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
        // Inner container view
        innerContainerView.layer.cornerRadius = cornerRadius
        innerContainerView.layer.masksToBounds = true
        animatingView.addSubview(innerContainerView)
        NSLayoutConstraint.activate([
            animatingView.widthAnchor.constraint(equalToConstant: cardFrame.width),
            animatingView.heightAnchor.constraint(equalToConstant: cardFrame.height),
            animatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            innerContainerView.widthAnchor.constraint(equalToConstant: cardFrame.width),
            innerContainerView.heightAnchor.constraint(equalToConstant: cardFrame.height),
            innerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            innerContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Gradient layer
        gradientLayer.frame = updateGradientLayerFrame()
        innerContainerView.layer.addSublayer(gradientLayer)
        
        // Masked inner view
        shapeLayer.path = updateShapeLayerPath()
        shapeLayer.fillColor = animatingView.backgroundColor?.cgColor
        innerContainerView.layer.addSublayer(shapeLayer)
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 4 // Adjust the duration as needed
        rotationAnimation.repeatCount = .infinity
        gradientLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
    
    private func updateGradientLayerFrame() -> CGRect {
        let sideSize = max(innerContainerView.bounds.width, innerContainerView.bounds.height) * 1.4
        return CGRect(
            origin: CGPoint(x: (innerContainerView.bounds.width-sideSize)/2, y: (innerContainerView.bounds.width-sideSize)/2),
            size: CGSize(width: sideSize, height: sideSize)
        )
    }
    
    private func updateShapeLayerPath() -> CGPath {
        UIBezierPath(roundedRect: innerContainerView.bounds.insetBy(dx: 3, dy: 3), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
    }
    
}
