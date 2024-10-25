//
//  ItemCell.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 25.10.2024.
//

import UIKit

class ItemCell: UITableViewCell {
    
    public static let reuseIdentifier = String(describing: ItemCell.self)
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let icon = UIImage(resource: .chevronLeft).withHorizontallyFlippedOrientation().withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    private func initCommon() {
        selectionStyle = .none
        backgroundColor = .clear
        configureContainerView()
        configureTitleLabel()
        configureIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }
    
    private func configureContainerView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
        ])
        
        containerView.layer.cornerRadius = 10
        // Give some shadow
        containerView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor   = UIColor.gray.cgColor
        containerView.layer.shadowRadius  = 7
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = .zero
        containerView.layer.rasterizationScale = UIScreen.main.scale
        containerView.layer.shouldRasterize = true
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    private func configureIndicator() {
        containerView.addSubview(disclosureIndicator)
        NSLayoutConstraint.activate([
            disclosureIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 12),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    public final func configure(with data: String) {
        titleLabel.text = data
    }
}
