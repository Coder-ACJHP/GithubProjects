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
        
        barSwipeFilter = createBarsSwipeFilter(
            inputImage: fromCIImage,
            inputTargetImage: toCIImage,
            inputAngle: NSNumber(value: CGFloat.pi),
            inputWidth: 80.0,
            inputBarOffset: 10.0
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
        guard let barSwipeFilter = barSwipeFilter,
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
            // Update the barSwipe effect
            barSwipeFilter.setValue(currentTime, forKey: kCIInputTimeKey)
            if let outputImage = barSwipeFilter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
            // Gradually increase the opacity of the destination view
            toView.alpha = CGFloat(currentTime)
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



