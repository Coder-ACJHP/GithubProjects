//
//  ModEffectTransition.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 24.10.2024.
//

import Foundation
import UIKit
import CoreImage

// MARK: - Custom UIViewController Mod Transition

class ModEffectTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    private let ciContext: CIContext
    private var modFilter: CIFilter?
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
        
        // Ensure both views are the same size
        let targetSize = fromView.bounds.size
        guard let fromImage = fromView.snapshotImage()?.resized(to: targetSize),
              let fromCIImage = CIImage(image: fromImage),
              let toImage = toView.snapshotImage()?.resized(to: targetSize),
              let toCIImage = CIImage(image: toImage) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Setup the mod filter with appropriate center and extent
        let ciCenter = CIVector(x: toCIImage.extent.width / 2, y: toCIImage.extent.height / 2)
        // Set the appropriate angle for presentation and dismissal
        let angle: CGFloat = isPresenting ? .pi : degreeToRadians(degree: 180)
        
        modFilter = createModTransition(
            inputImage: isPresenting ? fromCIImage : toCIImage,
            inputTargetImage: isPresenting ? toCIImage : fromCIImage,
            inputCenter: ciCenter,
            inputAngle: NSNumber(value: angle),
            inputRadius: NSNumber(value: min(targetSize.width/2, targetSize.height/2)),
            inputCompression: NSNumber(value: 300)
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
        guard let modFilter = modFilter,
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
        currentTime = min(max(currentTime, 0.0), 1.0)
        
        if currentTime <= 0.0 || currentTime >= 1.0 {
            // End the transition
            displayLink.invalidate()
            displayLink.remove(from: .main, forMode: .common)
            self.displayLink = nil
            // Ensure the transition ends cleanly
            imageView.removeFromSuperview()
            toView.alpha = 1.0
            transitionContext?.completeTransition(true)
        } else {
            // Update the mod effect
            modFilter.setValue(currentTime, forKey: kCIInputTimeKey)
            if let outputImage = modFilter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
            // Gradually increase the opacity of the destination view
            toView.alpha = CGFloat(currentTime)
        }
    }
    
    func createModTransition(
        inputImage: CIImage,
        inputTargetImage: CIImage,
        inputCenter: CIVector = CIVector(
            x: 150.0,
            y: 150.0
        ),
        inputTime: NSNumber = 0,
        inputAngle: NSNumber = 2,
        inputRadius: NSNumber = 150,
        inputCompression: NSNumber = 300
    ) -> CIFilter? {
        guard let filter = CIFilter(name: "CIModTransition") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputTargetImage, forKey: kCIInputTargetImageKey)
        filter.setValue(inputCenter, forKey: kCIInputCenterKey)
        filter.setValue(inputTime, forKey: kCIInputTimeKey)
        filter.setValue(inputAngle, forKey: kCIInputAngleKey)
        filter.setValue(inputRadius, forKey: kCIInputRadiusKey)
        filter.setValue(inputCompression, forKey:  "inputCompression")
        return filter
    }
}
