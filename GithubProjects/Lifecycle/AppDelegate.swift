//
//  AppDelegate.swift
//  CarouselCollectionView
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let windowFrame = UIScreen.main.bounds
        window = UIWindow(frame: windowFrame)
//        let rootViewController = UINavigationController(rootViewController: MainViewController())
//        window?.rootViewController = rootViewController
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

