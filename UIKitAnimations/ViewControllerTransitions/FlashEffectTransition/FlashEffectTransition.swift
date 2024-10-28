//
//  FlashEffectTransition.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import Foundation
import UIKit
import CoreImage

// MARK: - Custom UIViewController AccordionFold Transition

class FlashEffectTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    private let ciContext: CIContext
    private var flashFilter: CIFilter?
    private var displayLink: CADisplayLink?
    private var containerView: UIView?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var currentTime: CGFloat = 0.0
    private var color: UIColor = .white
    private var isPresenting: Bool
    
    init(duration: TimeInterval = 1.0, color: UIColor = .white, isPresenting: Bool) {
        self.duration = duration
        self.color = color
        self.isPresenting = isPresenting
        guard let mtlDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Cannot create CIContext MTLDevice")
        }
        self.ciContext = CIContext(mtlDevice: mtlDevice)
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Ensure both views are the same size
        let targetSize = fromView.bounds.size
        guard let fromImage = fromView.snapshotImage()?.resized(to: targetSize),
              let fromCIImage = CIImage(image: fromImage),
              let toImage = toView.snapshotImage()?.resized(to: targetSize),
              let toCIImage = CIImage(image: toImage) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Setup the ripple filter with appropriate center and extent
        let ciCenter = CIVector(x: toCIImage.extent.width / 2, y: toCIImage.extent.height / 2)
        let ciExtent = CIVector(x: 0, y: 0, z: toCIImage.extent.width, w: toCIImage.extent.height)
        
        flashFilter = createFlashFilter(
            inputImage: fromCIImage,
            inputTargetImage: toCIImage,
            inputCenter: ciCenter,
            inputExtent: ciExtent,
            inputColor: CIColor(color: self.color)
        )
        
        containerView = transitionContext.containerView
        self.transitionContext = transitionContext
        
        // Add the destination view and a temporary image view
        containerView?.addSubview(toView)
        toView.alpha = 0
        
        let imageView = UIImageView(frame: containerView!.bounds)
        containerView?.addSubview(imageView)
        
        // Set the initial value of currentTime based on whether it's presenting or dismissing
        currentTime = isPresenting ? .zero : 1.0
        
        // Start the display link to animate the transition
        startDisplayLink()
    }
    
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTransition(_:)))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateTransition(_ displayLink: CADisplayLink) {
        guard let filter = flashFilter,
              let containerView = containerView,
              let imageView = containerView.subviews.compactMap({ $0 as? UIImageView }).first,
              let toView = transitionContext?.view(forKey: .to)
        else { return }
        
        // Adjust `currentTime` based on whether it’s presenting or dismissing
        if isPresenting {
            currentTime += CGFloat(displayLink.duration) / CGFloat(duration)
        } else {
            currentTime -= CGFloat(displayLink.duration) / CGFloat(duration)
        }
        // Clamp value between 0 and 1
        let progress = min(max(currentTime, 0.0), 1.0)
        
        if progress <= 0.0 || progress >= 1.0 {
            // End the transition
            displayLink.invalidate()
            displayLink.remove(from: .main, forMode: .common)
            self.displayLink = nil
            // Ensure the transition ends cleanly
            imageView.removeFromSuperview()
            toView.alpha = 1.0
            transitionContext?.completeTransition(true)
        } else {
            // Update the flash effect
            filter.setValue(currentTime, forKey: kCIInputTimeKey)
            if let outputImage = filter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
            // Gradually increase the opacity of the destination view
            toView.alpha = CGFloat(currentTime)
        }
    }
    
    func createFlashFilter(
        inputImage: CIImage,
        inputTargetImage: CIImage,
        inputCenter: CIVector = CIVector(
            x: 150.0,
            y: 150.0
        ),
        inputExtent: CIVector = CIVector(
            x: 0.0,
            y: 0.0,
            z: 300.0,
            w: 300.0
        ),
        inputColor: CIColor,
        inputTime: NSNumber = 0,
        inputMaxStriationRadius: NSNumber = 2.58,
        inputStriationStrength: NSNumber = 0.5,
        inputStriationContrast: NSNumber = 1.375,
        inputFadeThreshold: NSNumber = 0.85
    ) -> CIFilter? {
        guard let filter = CIFilter(name: "CIFlashTransition") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputTargetImage, forKey: kCIInputTargetImageKey)
        filter.setValue(inputCenter, forKey: kCIInputCenterKey)
        filter.setValue(inputExtent, forKey: kCIInputExtentKey)
        filter.setValue(inputColor, forKey: kCIInputColorKey)
        filter.setValue(inputTime, forKey: kCIInputTimeKey)
        filter.setValue(inputMaxStriationRadius, forKey: "inputMaxStriationRadius")
        filter.setValue(inputStriationStrength, forKey: "inputStriationStrength")
        filter.setValue(inputStriationContrast, forKey: "inputStriationContrast")
        filter.setValue(inputFadeThreshold, forKey: "inputFadeThreshold")
        return filter
    }
}
