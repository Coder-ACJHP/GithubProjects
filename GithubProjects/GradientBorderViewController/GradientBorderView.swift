//
//  GradientBorderView.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 14.12.2024.
//

import UIKit

class GradientBorderView: UIView {

    // MARK: - Public Properties
    public var cornerRadius: CGFloat = 10 {
        didSet {
            updateCornerRadius()
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    // MARK: - Private Properties
    private let innerContainerView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    // MARK: - Initializers
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init(frame: frame)
        setupView(withColors: colors)
    }

    // MARK: - Setup
    private func setupView(withColors colors: [UIColor]) {
        translatesAutoresizingMaskIntoConstraints = false
        setupShadow()
        setupInnerContainerView()
        setupGradientLayer(withColors: colors)
        setupShapeLayer()
    }

    private func setupShadow() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 25.0
        layer.shadowOffset = .zero
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.allowsEdgeAntialiasing = true
    }

    private func setupInnerContainerView() {
        innerContainerView.translatesAutoresizingMaskIntoConstraints = false
        innerContainerView.backgroundColor = backgroundColor ?? .white
        innerContainerView.layer.cornerRadius = cornerRadius
        innerContainerView.layer.masksToBounds = true
        addSubview(innerContainerView)
        NSLayoutConstraint.activate([
            innerContainerView.topAnchor.constraint(equalTo: topAnchor),
            innerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            innerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupGradientLayer(withColors colors: [UIColor]) {
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = colors.map { $0.cgColor }
        innerContainerView.layer.addSublayer(gradientLayer)
    }

    private func setupShapeLayer() {
        shapeLayer.fillColor = backgroundColor?.cgColor
        innerContainerView.layer.addSublayer(shapeLayer)
    }

    // MARK: - Layout Updates
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayerFrame()
        updateShapeLayerPath()
    }

    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
        innerContainerView.layer.cornerRadius = cornerRadius
        updateShapeLayerPath()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

    private func updateBackgroundColor() {
        shapeLayer.fillColor = backgroundColor?.cgColor
        innerContainerView.backgroundColor = backgroundColor
    }

    private func updateGradientLayerFrame() {
        let sideSize = max(innerContainerView.bounds.width, innerContainerView.bounds.height) * 1.4
        gradientLayer.frame = CGRect(
            origin: CGPoint(x: (innerContainerView.bounds.width - sideSize) / 2,
                            y: (innerContainerView.bounds.height - sideSize) / 2),
            size: CGSize(width: sideSize, height: sideSize)
        )
    }

    private func updateShapeLayerPath() {
        shapeLayer.path = UIBezierPath(
            roundedRect: innerContainerView.bounds.insetBy(dx: 3, dy: 3),
            cornerRadius: cornerRadius
        ).cgPath
    }

    // MARK: - Public Methods
    public func startAnimation(duration: TimeInterval = 4) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity
        gradientLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    public func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
}
