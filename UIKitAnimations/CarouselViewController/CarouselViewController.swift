//
//  CarouselViewController.swift
//  CarouselCollectionView
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

class CarouselViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast // Smooth scrolling effect
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        titleAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
        tintColor = .black
        hasBackButton = true
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension CarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: UICollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.contentView.layer.cornerRadius = 30
        cell.contentView.backgroundColor = .white
        return cell
    }
}

extension CarouselViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let estimatedIndex = targetContentOffset.pointee.x / cellWidthIncludingSpacing
        let index: CGFloat

        if velocity.x > 0 { index = ceil(estimatedIndex)
        } else if velocity.x < 0 { index = floor(estimatedIndex)
        } else { index = round(estimatedIndex)
        }

        targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing, y: 0)
    }
}
