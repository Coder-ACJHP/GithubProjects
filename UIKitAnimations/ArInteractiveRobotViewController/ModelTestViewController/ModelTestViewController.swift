//
//  ModelTestViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 12.11.2024.
//

import UIKit
import SceneKit
import AVKit

class ModelTestViewController: BaseViewController {
    
    public var sceneView: SCNView!
    public var sceneViewContainer = UIView()
    public var backgroundLayer = CAGradientLayer()
    public var modelRootNode: SCNNode?
    public var cameraNode: SCNNode!
    public var modelHeightMultiplier = 1.0//0.35
    public var character: Character!
    
    // Timer
    public var idleStateTimer: Timer?
    // Konuşma için synthesizer
    public let speechSynthesizer = AVSpeechSynthesizer()
    private var isKeyboardVisible = false
    
    private var bottomCompConstraint: NSLayoutConstraint!
    private let bottomComponentsContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textInputView: UITextField = {
        let textField = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: 335, height: 50)))
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.textColor = #colorLiteral(red: 0.131020546, green: 0.1417218447, blue: 0.1572332978, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.masksToBounds = false
        textField.layer.shadowPath = UIBezierPath(roundedRect: textField.bounds, cornerRadius: textField.layer.cornerRadius).cgPath
        textField.layer.shadowColor   = UIColor(hexString: "#C5AAC1").withAlphaComponent(0.66).cgColor
        textField.layer.shadowRadius  = 5
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowOffset = .zero
        textField.layer.rasterizationScale = UIScreen.main.scale
        textField.layer.shouldRasterize = true
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Bana birşeyler sor",
            attributes: [
                .font : UIFont.systemFont(ofSize: 15, weight: .medium),
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let buttonsAction: Selector = {
        return #selector(handleButtonPress(_:))
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.gray, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = btn.frame.width / 2
        btn.layer.masksToBounds = false
        btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius: btn.layer.cornerRadius).cgPath
        btn.layer.shadowColor   = UIColor(hexString: "#C5AAC1").withAlphaComponent(0.66).cgColor
        btn.layer.shadowRadius  = 5
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.rasterizationScale = UIScreen.main.scale
        btn.layer.shouldRasterize = true
        btn.addTarget(self, action: buttonsAction, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray
        configureNavigationBar()
        configureSceneContainerView()
        configureSceneView()
        configureGradientBackground()
        configure3Dmodel(named: "handsomeGuy.scn")
        configureBottomComponentContainer()
        configureKeyboardListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            startIdleStateAnimation()
            let text = "Welcome to your VocaRise ai personal assistant"
            speakText(text)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update shadow path
        textInputView.layer.shadowPath = UIBezierPath(
            roundedRect: textInputView.bounds, cornerRadius: textInputView.layer.cornerRadius
        ).cgPath
        // Update gradient layer frame
        updateGradientLayerFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBlinkRandomizeTimer()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureSceneContainerView() {
        sceneViewContainer.backgroundColor = .clear
        sceneViewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneViewContainer)
        NSLayoutConstraint.activate([
            sceneViewContainer.topAnchor.constraint(equalTo: navbar.bottomAnchor),
            sceneViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneViewContainer.heightAnchor.constraint(equalToConstant: view.frame.height * modelHeightMultiplier)
        ])
    }
    
    private func configureSceneView() {
        sceneView = SCNView(frame: self.view.frame)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneViewContainer.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: sceneViewContainer.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: sceneViewContainer.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: sceneViewContainer.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: sceneViewContainer.bottomAnchor)
        ])
        // Create scene and assign it to sceneView
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = false // Kamera kontrolünü etkinleştir (modeli döndürmek ve yakınlaştırmak için)
        sceneView.backgroundColor = UIColor.clear // Arka plan rengi
        sceneView.autoenablesDefaultLighting = true
        // Add camera to word
        setupCamera(to: scene)
    }
    
    private func configure3Dmodel(named: String) {
        guard let scene = SCNScene(named: "art.scnassets/\(named)") else {
            return print("Model yüklenemedi.")
        }
        modelRootNode = scene.rootNode.clone()
        modelRootNode?.position = SCNVector3(0, 0, 0)
        modelRootNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        sceneView.scene?.rootNode.addChildNode(modelRootNode!)
        character = Character(from: modelRootNode)
        // Update camera position here
        updateCameraPosition()
    }
    
    private func setupCamera(to scene: SCNScene) {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func updateCameraPosition() {
        guard let camera = cameraNode else { return }
        let posiZ = min(modelRootNode?.boundingBox.min.z ?? .zero, modelRootNode?.boundingBox.max.z ?? .zero) / 2
        camera.position = SCNVector3(
            x: sceneView.scene?.rootNode.position.x ?? 0,
            y: .zero,
            z: abs(posiZ)
        )
    }
    
    private func configureGradientBackground() {
        sceneViewContainer.layoutIfNeeded()
        // Create the gradient layer
        backgroundLayer.frame = sceneViewContainer.bounds
        
        // Define gradient colors (e.g., from top to bottom)
        backgroundLayer.colors = [
            UIColor.blue.cgColor,   // Start color (top)
            UIColor.purple.cgColor  // End color (bottom)
        ]
        
        // Set gradient start and end points (optional customization)
        backgroundLayer.startPoint = CGPoint(x: 0.5, y: 0.0)  // Start at the top
        backgroundLayer.endPoint = CGPoint(x: 0.5, y: 1.0)    // End at the bottom
        
        // Add the gradient layer to the main view (below SceneView)
        sceneViewContainer.layer.insertSublayer(backgroundLayer, at: .zero)
    }
    
    private func updateGradientLayerFrame() {
        backgroundLayer.frame = sceneViewContainer.bounds
    }
    
    private func configureBottomComponentContainer() {
        view.addSubview(bottomComponentsContainerView)
        bottomCompConstraint = bottomComponentsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomCompConstraint.isActive = true
        NSLayoutConstraint.activate([
            bottomComponentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomComponentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomComponentsContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        ])
        
        configureSendButton()
        configureTextInputView()
    }
    
    private func configureTextInputView() {
        bottomComponentsContainerView.addSubview(textInputView)
        textInputView.delegate = self
        NSLayoutConstraint.activate([
            textInputView.topAnchor.constraint(equalTo: bottomComponentsContainerView.topAnchor),
            textInputView.bottomAnchor.constraint(equalTo: bottomComponentsContainerView.bottomAnchor),
            textInputView.leadingAnchor.constraint(equalTo: bottomComponentsContainerView.leadingAnchor, constant: 18),
            textInputView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            textInputView.heightAnchor.constraint(equalToConstant: textInputView.frame.height)
        ])
    }
    
    private func configureSendButton() {
        bottomComponentsContainerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: bottomComponentsContainerView.topAnchor),
            sendButton.bottomAnchor.constraint(equalTo: bottomComponentsContainerView.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: bottomComponentsContainerView.trailingAnchor, constant: -18),
            sendButton.widthAnchor.constraint(equalToConstant: sendButton.frame.width),
            sendButton.heightAnchor.constraint(equalToConstant: sendButton.frame.height)
        ])
    }
    
    private func configureKeyboardListener() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self else { return }
            if let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                // Check if the keyboard is showing or hiding
                let screenHeight = UIScreen.main.bounds.height
                isKeyboardVisible = keyboardFrame.origin.y < screenHeight
                bottomCompConstraint.constant = isKeyboardVisible ? -keyboardFrame.height : .zero
                UIView.animate(withDuration: 0.35) { [weak self] in
                    guard let self else { return }
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func updateSendButtonState(isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1.0 : 0.5
    }

    // MARK: - Idle state trigger functions

    private func startIdleStateAnimation() {
        guard character.state == .none else { return }
        startBlinkEyes(duration: 0.2)
        startHeadRotateAnimation()
        startSlightlySmileAnimation()
        character.state = .idle
    }
    
    private func stopIdleStateAnimation() {
        stopBlinking()
        resetBlinkRandomizeTimer()
        stopHeadRotateAnimation()
        stopSlightlySmileAnimation()
        character.state = .none
    }

    // MARK: - Actions
    
    func animateLipSync(characterNode: SCNNode, visemes: [String], durations: [Double], completionHandler: @escaping () -> Void) {
        // Iterate through each viseme
        for (index, viseme) in visemes.enumerated() {
            let duration = durations[index]
            let halfDuration = duration / 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration * Double(index))) { [weak self] in
                guard let self = self else { return completionHandler() }
    
                // Animate based on the current viseme
                animateViseme(viseme: viseme, halfDuration: halfDuration)
                
                // Reset the mouth shape after the half duration has passed
                DispatchQueue.main.asyncAfter(deadline: .now() + halfDuration) { [weak self] in
                    guard let self = self else { return completionHandler() }
                                        
                    // Reset mouth shape and close jaw
                    self.resetMouthShape(duration: halfDuration)
                    self.animateJawClose(duration: halfDuration)
                }
            }
        }
        
        // Reset the `currentState` to `.none` after all animations are complete
        DispatchQueue.main.asyncAfter(deadline: .now() + durations.reduce(0, +)) {
            completionHandler()
        }
    }

    private func animateViseme(viseme: String, halfDuration: Double) {
        switch viseme {
        case "A", "E": // Wide mouth
            animateWiderMouth(duration: halfDuration)
        case "K", "S", "T": // Narrow wide mouth
            animateWideMouth(duration: halfDuration)
        case "O", "U": // Rounded mouth
            animateRoundedMouth(duration: halfDuration)
        case "M", "P", "B": // Closed mouth
            animateClosedMouth(duration: halfDuration)
        default:
            break
        }
    }

    func animateTalking(visemes: Array<String>) {
        guard let characterNode = modelRootNode else { return }
        // Update current state
        character.state = .talking
        // A broader list of visemes for testing
        animateLipSync(
            characterNode: characterNode,
            visemes: visemes,
            durations: Array(repeating: 0.15, count: visemes.count),
            completionHandler: { [weak self] in
                guard let self else { return }
                // Reset state mouth animation when finished
                character.state = .none
            }
        )
    }
    
    // MARK: - Talking (tts)
    
    private func speakText(_ text: String) {
        character.talkingText = text
        // Stop if talking
        speechSynthesizer.stopSpeaking(at: .immediate)
        // Create AVSpeechUtterance to speak
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4 // Speech speed rate
        utterance.pitchMultiplier = 0.5
        utterance.preUtteranceDelay = 0.15
        utterance.volume = 1
        if let language = detectLanguageOf(text: text) {
            let voice = AVSpeechSynthesisVoice(language: language.rawValue)
            utterance.voice = voice
        }
        // Konuşma işlemini başlat
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
    }
    
    @objc
    private func handleButtonPress(_ sender: UIButton) {
        if isKeyboardVisible { view.endEditing(true) }
        guard let text = textInputView.text else { return }
        speakText(text)
        textInputView.text = nil
        updateSendButtonState(isEnabled: false)
    }
}

extension ModelTestViewController: UITextFieldDelegate, UIGestureRecognizerDelegate {
    
}

// MARK: - AVSpeechSynthesizerDelegate

extension ModelTestViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Get text using characterRange
        guard let word = character.talkingText.substring(with: characterRange) else { return }
        // Start talking animation
        let visemes = Array(word).map({ String($0).uppercased() })
        animateTalking(visemes: visemes)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        updateSendButtonState(isEnabled: true)
    }
}
