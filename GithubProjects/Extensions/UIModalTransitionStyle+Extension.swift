//
//  UIModalTransitionStyle+Extension.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 25.10.2024.
//

import UIKit

extension UIModalTransitionStyle {
    // Custom push transition UINavigationController push animation like
    public static var push: UIModalTransitionStyle {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .moveIn
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let activeWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        activeWindow?.layer.add(transition, forKey: "pushAnimation")
        return UIModalTransitionStyle(rawValue: -1) ?? .crossDissolve
    }
    // Custom back transition UINavigationController back animation like
    public static var back: UIModalTransitionStyle {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .reveal
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let activeWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        activeWindow?.layer.add(transition, forKey: "backAnimation")
        return UIModalTransitionStyle(rawValue: -1) ?? .crossDissolve
    }
    
    public static var pullFromTheTop: UIModalTransitionStyle {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .push
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let activeWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        activeWindow?.layer.add(transition, forKey: "pullFromTheTop")
        return UIModalTransitionStyle(rawValue: -2) ?? .crossDissolve
    }
    
    public static var pushToTheBottom: UIModalTransitionStyle {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .push
        transition.subtype = .fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let activeWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        activeWindow?.layer.add(transition, forKey: "pushFromTheBottom")
        return UIModalTransitionStyle(rawValue: -3) ?? .crossDissolve
    }
}
