//
//  StackedItemsViewController.swift
//  CarouselCollectionView
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

class StackedItemsViewController: BaseViewController {
    
    public let backgroundImageView: UIImageView = {
        let image = UIImage(resource: .background)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private enum Direction {
        case left, right, none
    }
    
    private var itemsCount: Int = 5
    private var stackedItems = [UIView]()
    private var initialPosix: CGFloat = .zero
    private var animationDuration: CGFloat = 0.5

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureBackgroundView()
        configureContainerView()
        configureStackedItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateStackedItems(animated: true)
    }
    
    private func configureNavigationBar() {
        titleAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
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
    
    private func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(itemsCount * 12)),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func configureStackedItems() {
        containerView.layoutIfNeeded()
        for index in 0 ..< itemsCount {
            let leftRightInset = 20.0
            let itemWidth = view.bounds.width - (leftRightInset * 2)
            let notificationView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: itemWidth, height: 70)))
            notificationView.backgroundColor = .white
            notificationView.layer.cornerRadius = 6
            notificationView.layer.shadowPath = UIBezierPath(roundedRect: notificationView.frame, cornerRadius: notificationView.layer.cornerRadius).cgPath
            notificationView.layer.shadowColor = UIColor.black.cgColor
            notificationView.layer.shadowOffset = .zero
            notificationView.layer.shadowOpacity = 0.7
            notificationView.layer.shadowRadius = 15
            notificationView.layer.rasterizationScale = UIScreen.main.scale
            notificationView.layer.allowsEdgeAntialiasing = true
            notificationView.layer.shouldRasterize = true
            notificationView.tag = index
            let action = #selector(dragNotificationView(_:))
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: action)
            notificationView.addGestureRecognizer(panGestureRecognizer)
            
            containerView.addSubview(notificationView)
            notificationView.frame.origin = CGPoint(
                x: (containerView.frame.width - notificationView.frame.width) / 2,
                y: 0
            )
            
            stackedItems.append(notificationView)
        }
    }
    
    private func updateStackedItems(animated: Bool) {
        let copyStackedItems = stackedItems.reversed()
        let scale = 0.08
        let translation = -12.0
        for (index, item) in copyStackedItems.enumerated().reversed() {
            let indexAsFloat = CGFloat(index)
            let scaleXY = 1.0 - (1.0 * (indexAsFloat * scale))
            let clapedScale = clamp(scaleXY, 0.5, 1.0)
            UIView.animate(withDuration: animated ? animationDuration : .zero) {
                item.transform = CGAffineTransform(translationX: 0, y: -(indexAsFloat * translation)).scaledBy(x: clapedScale, y: clapedScale)
            }
        }
    }
    
    // MARK: - Helpers
    
    func clamp<T: Comparable>(_ value: T, _ min: T, _ max: T) -> T {
        Swift.min(Swift.max(value, min), max)
    }
    
    private func checkIsOutOfBounds(_ swipingView: UIView) -> Bool {
        let lastPosition = swipingView.frame.origin.x + (swipingView.frame.width / 2)
        if lastPosition > view.bounds.width || lastPosition < 0 {
            return true
        }
        return false
    }
    
    private func findDirectionOf(view: UIView) -> Direction {
        let lastPosition = view.frame.origin.x + (view.frame.width / 2)
        if lastPosition > view.bounds.width {
            return .left
        } else if lastPosition < 0 {
            return .right
        } else { return .none }
    }
    
    private func removeViewWithAnimationIfNeeded(view swipingView: UIView, forDirection direction: Direction) {
        switch direction {
        case .left:
            UIView.animate(withDuration: animationDuration) {
                swipingView.frame.origin.x = self.view.bounds.width
            } completion: { [weak self] _ in
                guard let self else { return }
                swipingView.removeFromSuperview()
                stackedItems.removeAll(where: { $0.tag == swipingView.tag })
            }
        case .right:
            UIView.animate(withDuration: animationDuration) {
                swipingView.frame.origin.x = -self.view.bounds.width
            } completion: { [weak self] _ in
                guard let self else { return }
                swipingView.removeFromSuperview()
                stackedItems.removeAll(where: { $0.tag == swipingView.tag })
            }
        default: break
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func dragNotificationView(_ gesture: UIPanGestureRecognizer) {
        guard let swipingView = gesture.view else { return }
        let translation = gesture.translation(in: swipingView.superview)

        switch gesture.state {
        case .possible: break
        case .began: 
            initialPosix = swipingView.frame.origin.x
        case .changed:
            // Just move x direction based on translation
            let newPosiX = initialPosix + translation.x
            swipingView.frame.origin.x = newPosiX
        case .ended:
            // Check it needs to remove or not
            if checkIsOutOfBounds(swipingView) {
                let swipeDirection = findDirectionOf(view: swipingView)
                removeViewWithAnimationIfNeeded(view: swipingView, forDirection: swipeDirection)
                updateStackedItems(animated: true)
            } else {
                // Return the view to it's original position
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    guard let self else { return }
                    swipingView.frame.origin.x = (containerView.frame.width - swipingView.frame.width) / 2
                }
            }
        case .cancelled:
            // Snap to original position
            swipingView.frame.origin.x = initialPosix
        case .failed:break
        case .recognized:break
        default:break
        }
        
    }
}
