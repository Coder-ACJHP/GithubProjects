//
//  CarouselFlowLayout.swift
//  CarouselCollectionView
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    let scaleFactor: CGFloat = 0.7 // Minimum scale for side cells
    
    override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        scrollDirection = .horizontal
        // Define cell size
        itemSize = collectionView.bounds.inset(by: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)).size
        // Calculate left right spaces
        let leftRightInset = (collectionView.bounds.width - itemSize.width) / 2
        // Adjust the minimum line spacing dynamically based on the scale factor
        minimumLineSpacing = calculateMinimumLineSpacing(forScale: scaleFactor)
        // Center cells in the screen
        sectionInset = .init(top: .zero, left: leftRightInset, bottom: .zero, right: leftRightInset)
    }
    
    private func calculateMinimumLineSpacing(forScale scale: CGFloat) -> CGFloat {
        // Calculate the width reduction due to scaling
        let scaledWidth = itemSize.width * scale
        // Calculate the spacing so that the smaller cells appear snug next to each other
        let spacing = (itemSize.width - scaledWidth) / 2.2
        return -spacing // Negative spacing ensures tight alignment
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        let centerX = collectionView!.contentOffset.x + collectionView!.frame.size.width / 2
        // Iterate over the copied attributes, not the originals
        let copiedAttributesArray = attributesArray.map { $0.copy() as! UICollectionViewLayoutAttributes }
        for attributes in copiedAttributesArray {
            let distance = abs(attributes.center.x - centerX)
            let normalizedDistance = distance / (collectionView!.frame.width / 2)
            let scale = 1 - (1 - scaleFactor) * min(1, normalizedDistance)

            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.alpha = scale // Adjust opacity based on scale
        }

        return copiedAttributesArray
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true // Ensure the layout updates during scrolling
    }
}

