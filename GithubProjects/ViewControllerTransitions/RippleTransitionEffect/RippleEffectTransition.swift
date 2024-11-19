//
//  RippleEffectTransition.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 23.10.2024.
//

import Foundation
import UIKit
import CoreImage

// MARK: - Custom UIViewController Ripple Transition

class RippleEffectTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    private let ciContext: CIContext
    private var rippleFilter: CIFilter?
    private var displayLink: CADisplayLink?
    private var containerView: UIView?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var currentTime: CGFloat = 0.0
    
    init(duration: TimeInterval = 1.0) {
        self.duration = duration
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

        rippleFilter = createRippleTransitionFilter(
            inputImage: fromCIImage,
            inputTargetImage: toCIImage,
            inputShadingImage: CIImage(), // Use proper shading image
            inputCenter: ciCenter,
            inputExtent: ciExtent,
            inputWidth: NSNumber(value: max(targetSize.width, targetSize.height)),
            inputScale: 80.0 // Increased scale for smoother ripple
        )

        containerView = transitionContext.containerView
        self.transitionContext = transitionContext

        // Add the destination view and a temporary image view
        containerView?.addSubview(toView)
        toView.alpha = 0

        let imageView = UIImageView(frame: containerView!.bounds)
        containerView?.addSubview(imageView)

        // Start the display link to animate the transition
        startDisplayLink()
    }
    
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTransition(_:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateTransition(_ displayLink: CADisplayLink) {
        guard let rippleFilter = rippleFilter,
              let containerView = containerView,
              let imageView = containerView.subviews.compactMap({ $0 as? UIImageView }).first,
              let toView = transitionContext?.view(forKey: .to)
        else { return }

        // Smoothly increment time between 0 and 1
        currentTime += CGFloat(displayLink.duration) / CGFloat(duration)

        if currentTime >= 1.0 {
            // End the transition
            displayLink.invalidate()
            displayLink.remove(from: .main, forMode: .common)
            self.displayLink = nil
            // Ensure the transition ends cleanly
            imageView.removeFromSuperview()
            toView.alpha = 1.0
            transitionContext?.completeTransition(true)
        } else {
            // Update the ripple effect
            rippleFilter.setValue(currentTime, forKey: kCIInputTimeKey)
            if let outputImage = rippleFilter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
            // Gradually increase the opacity of the destination view
            toView.alpha = CGFloat(currentTime)
        }
    }
    
    func createRippleTransitionFilter(
        inputImage: CIImage,
        inputTargetImage: CIImage,
        inputShadingImage: CIImage,
        inputCenter: CIVector,
        inputExtent: CIVector,
        inputTime: NSNumber = 0,
        inputWidth: NSNumber = 100,
        inputScale: NSNumber = 50
    ) -> CIFilter? {
        guard let filter = CIFilter(name: "CIRippleTransition") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputTargetImage, forKey: kCIInputTargetImageKey)
        filter.setValue(inputShadingImage, forKey: kCIInputShadingImageKey)
        filter.setValue(inputCenter, forKey: kCIInputCenterKey)
        filter.setValue(inputExtent, forKey: kCIInputExtentKey)
        filter.setValue(inputTime, forKey: kCIInputTimeKey)
        filter.setValue(inputWidth, forKey: kCIInputWidthKey)
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        return filter
    }
}
