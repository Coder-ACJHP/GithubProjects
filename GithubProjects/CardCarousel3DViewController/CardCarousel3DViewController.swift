//
//  CardCarousel3DViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 28.10.2024.
//

import UIKit

class CardCarousel3DViewController: BaseViewController {

    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    let transformLayer = CATransformLayer()
    
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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        transformLayer.frame = view.bounds
        view.layer.addSublayer(transformLayer)
        
        // Getting images from Assets so you need to change here and add your own image names
        (0...5).forEach { index in
            addImageCard(name: "intro-oliveria-\(index+1)")
        }
        
        turnCarosel()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func addImageCard(name: String) {
        
        let cardSize = CGSize(width: 200, height: 300)
        let imageLayer = CALayer()
        let origin = CGPoint(x: (view.bounds.width / 2) - (cardSize.width / 2),
                             y: (view.bounds.height / 2) - (cardSize.height / 2))
        imageLayer.frame = CGRect(origin: origin, size: cardSize)
        
        guard let cardImage = UIImage(named: name)?.cgImage else { return }
        imageLayer.contents = cardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.borderColor = UIColor.lightGray.cgColor
        imageLayer.borderWidth = 3.0
        imageLayer.cornerRadius = 8
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        transformLayer.addSublayer(imageLayer)
    }
    
    private func turnCarosel() {
        
        guard let transformSubLayers = transformLayer.sublayers else { return }
        
        let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
        var angleOffset = currentAngle
        
        transformSubLayers.forEach { (layer) in
            
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(transform, degreeToRadians(degree: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            
            angleOffset += segmentForImageCard
        }
    }

    @objc private func handlePan(_ gestureRecognier: UIPanGestureRecognizer) {
        
        let xOffset = gestureRecognier.translation(in: view).x
        
        if gestureRecognier.state == .began {
            currentOffset = 0
        }
        
        let xDifference = xOffset * 0.6 - currentOffset
        currentOffset += xDifference
        currentAngle += xDifference
        
        turnCarosel()
    }
}
