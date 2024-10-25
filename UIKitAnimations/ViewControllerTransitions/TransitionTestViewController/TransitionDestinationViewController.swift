//
//  TransitionDestinationViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit

class TransitionDestinationViewController: BaseViewController {

    public let backgroundImageView: UIImageView = {
        let image = UIImage(resource: .backgroundImage2)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBackgroundView()
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
}
