//
//  CarouselViewCell.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 25.10.2024.
//

import UIKit

class CarouselViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = String(describing: CarouselViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    private func initCommon() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        // Give some shadow
        contentView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor   = UIColor.gray.cgColor
        contentView.layer.shadowRadius  = contentView.layer.cornerRadius
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = .zero
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.layer.shouldRasterize = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
}
