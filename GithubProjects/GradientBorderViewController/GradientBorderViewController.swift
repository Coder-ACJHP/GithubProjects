//
//  GradientBorderViewController.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 10.12.2024.
//

import UIKit

class GradientBorderViewController: BaseViewController {
    
    private lazy var gradientBoderView: GradientBorderView = {
        let width = view.bounds.width * 0.6
        let cardFrame = CGRect(origin: .zero, size: CGSize(width: width, height: width * 1.2))
        let colors: [UIColor] = [.yellow, .red, .green, .blue, .purple, .cyan, .yellow]
        return GradientBorderView(frame: cardFrame, colors: colors)
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
        view.backgroundColor = .appLightGray
        configureNavigationBar()
        configureGradientBorderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradientBoderView.startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gradientBoderView.stopAnimation()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureGradientBorderView() {
        gradientBoderView.backgroundColor = .white
        view.addSubview(gradientBoderView)
        NSLayoutConstraint.activate([
            gradientBoderView.widthAnchor.constraint(equalToConstant: gradientBoderView.frame.width),
            gradientBoderView.heightAnchor.constraint(equalToConstant: gradientBoderView.frame.height),
            gradientBoderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientBoderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
