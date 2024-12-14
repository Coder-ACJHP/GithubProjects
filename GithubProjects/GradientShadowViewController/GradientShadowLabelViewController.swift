//
//  GradientShadowLabelViewController.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 11.12.2024.
//

import Foundation
import UIKit

class GradientShadowLabelViewController: BaseViewController {
    
    private let gradientShadowLabel: GradientShadowLabel = {
        let label = GradientShadowLabel()
        label.text = "Hello World"
        label.font = UIFont.systemFont(ofSize: 50, weight: .black)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureGlowView()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureGlowView() {
        view.addSubview(gradientShadowLabel)
        NSLayoutConstraint.activate([
            gradientShadowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientShadowLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gradientShadowLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
            gradientShadowLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        ])
        gradientShadowLabel.applyGradientShadow(withColors: [.cyan, .red, .yellow, .orange, .cyan])
    }
}
