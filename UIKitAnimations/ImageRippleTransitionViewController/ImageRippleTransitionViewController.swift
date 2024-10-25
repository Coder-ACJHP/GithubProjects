//
//  ImageRippleTransitionViewController.swift
//  CarouselCollectionView
//
//  Created by Coder ACJHP on 23.10.2024.
//

import UIKit

class ImageRippleTransitionViewController: BaseViewController {
    
    public let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var duration: TimeInterval = 1.0 // Customize transition duration
    private var currentTime: CGFloat = .zero
    private var displayLink: CADisplayLink?
    private var rippleFilter: CIFilter?
    private var ciContext: CIContext?
    private var isAnimationStarted = false
    private var isImageNeedsToSwitch = false
    private var transitionImages: Array<ImageResource> = [
        .background, .backgroundImage2
    ]
    private var resizedTransitionImages: Array<UIImage?> = []
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        if let mtlDevice = MTLCreateSystemDefaultDevice() {
            ciContext = CIContext(mtlDevice: mtlDevice)
        }
        
        let targetSize = UIScreen.main.bounds.size
        for image in transitionImages {
            let fullSizeImage = UIImage(resource: image)
            let resizedImage = resizeImage(fullSizeImage, to: targetSize)
            resizedTransitionImages.append(resizedImage)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
        configureBackgroundView()
        addTapGestureRecognizer()
    }
    
    private func configureNavigationBar() {
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
        let image: ImageResource = isImageNeedsToSwitch ? transitionImages.first! : transitionImages.last!
        backgroundImageView.image = UIImage(resource: image)
    }
    
    private func addTapGestureRecognizer() {
        let action = #selector(handleTapAction(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTapAction(_ gesture: UITapGestureRecognizer) {
        guard isAnimationStarted == false else { return }
        // Reset animation
        currentTime = .zero
        let location = gesture.location(in: view)
        applyRippleEffect(centered: location)
    }
    
    private func applyRippleEffect(centered atLocation: CGPoint) {
        // Create CIImages from UIImages
        guard let inputImage1 = isImageNeedsToSwitch ? resizedTransitionImages.first! : resizedTransitionImages.last!,
              let fromCIImage = CIImage(image: inputImage1),
              let inputImage2 = isImageNeedsToSwitch ? resizedTransitionImages.last! : resizedTransitionImages.first!,
              let toCIImage = CIImage(image: inputImage2)
        else { return print("Cannot create ciImages") }
        // Setup ripple filter
        
        // Switch the flag
        isImageNeedsToSwitch.toggle()
        
        // Calculate the correct center for Core Image coordinates (bottom-left origin)
        let ciCenter = CIVector(x: atLocation.x, y: toCIImage.extent.height - atLocation.y)
        // Define the extent to cover the entire view
        let ciExtent = CIVector(x: 0, y: 0, z: view.bounds.width, w: view.bounds.height)
        // Setup the ripple filter
        rippleFilter = createRippleTransitionFilter(
            inputImage: fromCIImage,
            inputTargetImage: toCIImage,
            inputShadingImage: CIImage(),
            inputCenter: ciCenter,          // Center from the middle of the view
            inputExtent: ciExtent,          // Bounds of the entire view
            inputWidth: NSNumber(value: 100),
            inputScale: 50.0
        )

        displayLink = CADisplayLink(target: self, selector: #selector(updateTransition))
        displayLink?.add(to: .main, forMode: .common)
        isAnimationStarted = true
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
    
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    @objc
    func updateTransition() {
        guard let displayLink, let ciContext, let rippleFilter else {
            return print("Missing required objects like displayLink or ciContext etc.")
        }
        currentTime += CGFloat(displayLink.duration) / CGFloat(duration)
        if currentTime >= duration {
            displayLink.invalidate()
            displayLink.remove(from: .main, forMode: .common)
            isAnimationStarted = false
        } else {
            rippleFilter.setValue(currentTime, forKey: kCIInputTimeKey)
            if let outputImage = rippleFilter.outputImage,
               let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                let resultImage = UIImage(cgImage: cgImage)
                backgroundImageView.image = resultImage
            }
        }
    }
}
