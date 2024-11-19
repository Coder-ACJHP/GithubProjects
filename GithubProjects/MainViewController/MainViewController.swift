//
//  MainViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit

class MainViewController: BaseViewController {
    
    struct Section {
        var title: String
        var items: Array<String>
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.layer.masksToBounds = true
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        let id = ItemCell.reuseIdentifier
        tableView.register(ItemCell.self, forCellReuseIdentifier: id)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let sections: Array<Section> = [
        .init(title: "Animations", items: [
            "Ripple On Images",
            "Tinder Like",
            "3D Parallax Card"
        ]),
        .init(title: "Lottie", items: [
            "2D Model Talking"
        ]),
        .init(title: "Custom Components", items: [
            "Zoom Center Cell",
            "3D Image Cards",
            "3D Stacked Items",
            "Custom Tabbar"
        ]),
        .init(title: "Transitions (bidirectional)", items: [
            "Ripple",
            "Bar Swipe",
            "Copy Machine",
            "Mod",
            "Flash",
            "Swipe"
        ]),
        .init(title: "SceneKit", items: [
            "3D Model Talking",
        ]),
        .init(title: "SpriteKit", items: [
            "Suggest Words"
        ])
    ]
    private let preferredCellHeight: CGFloat = 78.0
    private let preferredHeaderViewHeight: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Github Projects"
        tintColor = .black
        hasBackButton = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navbar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        preferredHeaderViewHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: preferredHeaderViewHeight)))
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .lightGray
        titleLabel.text = sections[section].title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = ItemCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemCell
        cell.configure(with: sections[indexPath.section].items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        preferredCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = sections[indexPath.section].items[indexPath.row]
        print(title)
        var destinationVC: UIViewController?
        switch title.lowercased() {
        case let str where str.contains("on images"):
            destinationVC = ImageRippleTransitionViewController(title: title)
        case let str where str.contains("tinder"):
            destinationVC = TinderLikeViewController(title: title)
        case let str where str.contains("zoom center cell"):
            destinationVC = CarouselViewController(title: title)
        case let str where str.contains("3d stacked items"):
            destinationVC = StackedItemsViewController(title: title)
        case let str where str.contains("3d parallax card"):
            destinationVC = Parallax3DCardEffectViewController(title: title)
        case let str where str.contains("3d image cards"):
            destinationVC = CardCarousel3DViewController(title: title)
        case let str where str.contains("custom tabbar"):
            destinationVC = CustomTabbarViewController(title: title)
        case let str where str.contains("ripple"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .ripple)
        case let str where str.contains("bar"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .barSwipe)
        case let str where str.contains("copy"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .copyMachine)
        case let str where str.contains("Mod"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .mod)
        case let str where str.contains("flash"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .flash)
        case let str where str.contains("swipe"):
            destinationVC = TransitionTestViewController(title: title, transitionEffect: .swipe)
        case let str where str.contains("3d model talking"):
            destinationVC = ModelTestViewController(title: title)
        case let str where str.contains("2d model talking"):
            destinationVC = TalkingHeadViewController(title: title)
        case let str where str.contains("suggest words"):
            destinationVC = WordGameViewController(title: title)
        default: break
        }
        
        guard let destinationVC else { return }
        destinationVC.modalTransitionStyle = .push
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: false)
    }
}
