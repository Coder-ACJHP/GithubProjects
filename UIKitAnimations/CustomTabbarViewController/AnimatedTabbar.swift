//
//  AnimatedTabbar.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 25.10.2024.
//

import UIKit

class AnimatedTabbar: UITabBar {

    private var pathShapeLayer: CAShapeLayer!
    private var centerWidth: CGFloat = .zero
    
    init() {
        super.init(frame: .zero)
        configureShapeLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        centerWidth = rect.width / 2
        updateLayerPath()
    }
    
    private func updateLayerPath() {
        pathShapeLayer.path = createCurvedTabPath()
        let layerAnimation = CABasicAnimation(keyPath: "strokeEnd")
        layerAnimation.fromValue = 0.0
        layerAnimation.toValue = 1.0
        layerAnimation.duration = 2.0
        layerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layerAnimation.isRemovedOnCompletion = false
        pathShapeLayer.add(layerAnimation, forKey: "pathAnimation")
        pathShapeLayer.strokeEnd = 1.0
    }

    private func configureShapeLayer() {
        pathShapeLayer = CAShapeLayer()
        pathShapeLayer.path = createCurvedTabPath()
        pathShapeLayer.strokeColor = UIColor.lightGray.cgColor
        pathShapeLayer.fillColor = #colorLiteral(red: 0.9782002568, green: 0.9782230258, blue: 0.9782107472, alpha: 1)
        pathShapeLayer.lineWidth = 0.5
        pathShapeLayer.shadowOffset = CGSize(width:0, height:0)
        pathShapeLayer.shadowRadius = 10
        pathShapeLayer.shadowColor = UIColor.gray.cgColor
        pathShapeLayer.shadowOpacity = 0.3
        layer.addSublayer(pathShapeLayer)
    }

    func createCurvedTabPath() -> CGPath {
        let height: CGFloat = 86.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
        
        path.addCurve(
            to: CGPoint(x: centerWidth, y: height - 25),
            controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
            controlPoint2: CGPoint(x: centerWidth - 35, y: height - 25)
        )
        path.addCurve(
            to: CGPoint(x: (centerWidth + height), y: 0),
            controlPoint1: CGPoint(x: centerWidth + 35, y: height - 25),
            controlPoint2: CGPoint(x: (centerWidth + 30), y: 0)
        )
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    func updatePathFor(item: UITabBarItem) {
        guard let selectedTabView = item.value(forKey: "view") as? UIView else { return }
        self.centerWidth = selectedTabView.frame.origin.x + (selectedTabView.frame.width / 2)
        updateLayerPath()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 74
        return sizeThatFits
    }
}
