//
//  BarsSwipeEffectTransition.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import UIKit
import CoreImage

// MARK: - Custom UIViewController BarsSwipe Transition

class BarsSwipeEffectTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    private let ciContext: CIContext
    private var barSwipeFilter: CIFilter?
    private var displayLink: CADisplayLink?
    private var containerView: UIView?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var currentTime: CGFloat = 0.0
    private var isPresenting: Bool
    
    init(duration: TimeInterval = 1.0, isPresenting: Bool) {
        self.duration = duration
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

        let targetSize = fromView.bounds.size
        guard let fromImage = fromView.snapshotImage()?.resized(to: targetSize),
              let fromCIImage = CIImage(image: fromImage),
              let toImage = toView.snapshotImage()?.resized(to: targetSize),
              let toCIImage = CIImage(image: toImage) else {
            transitionContext.completeTransition(false)
            return
        }

        // Set the appropriate angle for presentation and dismissal
        let angle: CGFloat = isPresenting ? .pi : degreeToRadians(degree: 180)

        barSwipeFilter = createBarsSwipeFilter(
            inputImage: isPresenting ? fromCIImage : toCIImage,
            inputTargetImage: isPresenting ? toCIImage : fromCIImage,
            inputAngle: NSNumber(value: angle),
            inputWidth: 80.0,
            inputBarOffset: 10.0
        )

        containerView = transitionContext.containerView
        self.transitionContext = transitionContext

        // Add the destination view to the hierarchy and hide it initially
        containerView?.addSubview(toView)
        toView.alpha = 0

        let imageView = UIImageView(frame: containerView!.bounds)
        containerView?.addSubview(imageView)

        // Start the animation loop
        startDisplayLink()
    }
    
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTransition(_:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateTransition(_ displayLink: CADisplayLink) {
        guard let barSwipeFilter = barSwipeFilter,
              let containerView = containerView,
              let imageView = containerView.subviews.compactMap({ $0 as? UIImageView }).first,
              let toView = transitionContext?.view(forKey: .to) else { return }

        // Update the progress depending on the transition direction
        currentTime += CGFloat(displayLink.duration) / CGFloat(duration)
        let progress = isPresenting ? currentTime : (1.0 - currentTime)

        if progress <= 0.0 || progress >= 1.0 {
            // Transition complete
            displayLink.invalidate()
            displayLink.remove(from: .main, forMode: .common)
            self.displayLink = nil
            imageView.removeFromSuperview()
            toView.alpha = 1.0
            transitionContext?.completeTransition(true)
        } else {
            // Update the bar swipe effect with current progress
            barSwipeFilter.setValue(progress, forKey: kCIInputTimeKey)
            if let outputImage = barSwipeFilter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
            // Adjust the view's opacity based on progress
            toView.alpha = progress
        }
    }

    func createBarsSwipeFilter(
        inputImage: CIImage,
        inputTargetImage: CIImage,
        inputAngle: NSNumber = 3.141592653589793,
        inputWidth: NSNumber = 30,
        inputBarOffset: NSNumber = 10,
        inputTime: NSNumber = 0) -> CIFilter? {
        guard let filter = CIFilter(name: "CIBarsSwipeTransition") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputTargetImage, forKey: kCIInputTargetImageKey)
        filter.setValue(inputAngle, forKey: kCIInputAngleKey)
        filter.setValue(inputWidth, forKey: kCIInputWidthKey)
        filter.setValue(inputBarOffset, forKey: "inputBarOffset")
        filter.setValue(inputTime, forKey: kCIInputTimeKey)
        return filter
    }
}




