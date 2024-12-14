//
//  GradientShadowLabel.swift
//  GithubProjects
//
//  Created by Coder ACJHP on 14.12.2024.
//

import UIKit

class GradientShadowLabel: UILabel {
    
    private var colors: [UIColor] = []
    private var shadowRadius: CGFloat = .zero
    private let shadowImageView = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure the shadowImageView matches the label bounds
        shadowImageView.frame = bounds.insetBy(dx: -3, dy: -3)
        shadowImageView.center = center
        applyGradientShadow()
    }
    
    func applyGradientShadow(withColors colors: [UIColor], radius: CGFloat = 10.0) {
        self.colors = colors
        self.shadowRadius = radius
        applyGradientShadow()
    }

    private func applyGradientShadow() {
        // 1. Render gradient as an image
        guard let gradientImage = createGradientImage(colors: colors, size: frame.size) else {
            return
        }
        
        // 2. Apply Gaussian blur to the image
        let blurredImage = applyGaussianBlur(to: gradientImage)
        
        // 3. Set the blurred image as a shadow
        shadowImageView.image = blurredImage
        shadowImageView.contentMode = .scaleAspectFit
        shadowImageView.clipsToBounds = true

        // Insert shadow image below the label
        if shadowImageView.superview == nil {
            superview?.insertSubview(shadowImageView, belowSubview: self)
        }
    }

    private func createGradientImage(colors: [UIColor], size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        // Start image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() } // Ensure the context is cleaned up

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Create and render gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        
        // Update the mask to fit the new bounds
        if let text = text, let font = font {
            let textLayer = CATextLayer()
            textLayer.string = text
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.frame = gradientLayer.bounds
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            gradientLayer.mask = textLayer
        }
        
        gradientLayer.render(in: context)

        // Retrieve and return the image
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func applyGaussianBlur(to image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let inputImage = CIImage(image: image) else { return nil }

        // Apply Gaussian blur
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(shadowRadius, forKey: kCIInputRadiusKey) // Adjust blur radius as needed

        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
