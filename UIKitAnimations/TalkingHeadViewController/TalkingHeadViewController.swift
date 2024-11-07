//
//  TalkingHeadViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 7.11.2024.
//

import UIKit
import Lottie
import AVFoundation
import NaturalLanguage

class TalkingHeadViewController: BaseViewController, AVSpeechSynthesizerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Preloaded Lottie animation views
    private var listeningAnimationView: LottieAnimationView!
    private var idleAnimationView: LottieAnimationView!
    private var typingAnimationView: LottieAnimationView!
    private var typingALotAnimationView: LottieAnimationView!
    private var animationToShow: LottieAnimationView?
    private var gradientLayer: CAGradientLayer!
    private var animationViewHeightMultiplier: CGFloat = 0.35
    private var isFromUser = true
    private let greetingMessage = """
    Merhaba! Ben yeni asistanın Mr.VocaRise, bana ingilizce hakkında istediğini sorabilirsin.
    """
    
    private let speechSynthesizer = AVSpeechSynthesizer() // Konuşma için synthesizer
    private var isKeyboardVisible = false
    
    private var messagesTableView: UITableView! // Mesajları gösterecek UITableView
    private var messages: [Message] = [] // Gelen mesajları tutacak array
    
    // Define the animation states
    private enum AnimationState {
        case listening, idle, typing, typingALot
    }
    private var oldAnimationState: AnimationState = .idle
    
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
        configureBottomComponentContainer()
        configureKeyboardListener()
        configureLottieViews()
        configureTapGesture()
        configureGradientView()
        configureMessagesTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        processGreetingMessage()
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
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureLottieViews() {
        listeningAnimationView = createAnimationView(name: "TalkingHead")
        idleAnimationView = createAnimationView(name: "TalkingHeadIdle")
        typingAnimationView = createAnimationView(name: "TalkingHeadWaiting")
        typingALotAnimationView = createAnimationView(name: "TalkingHeadConfuse")
        
        // Start with idle animation visible
        idleAnimationView.isHidden = false
    }
    
    private func createAnimationView(name: String) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.isHidden = true // Hidden initially
        view.addSubview(animationView)
        // Set up layout constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: navbar.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: animationViewHeightMultiplier)
        ])
        return animationView
    }
    
    private func configureGradientView() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#f45e29").cgColor, UIColor.appLightGray.cgColor]
        gradientLayer.startPoint = .init(x: 0.5, y: 0.0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.7]
        view.layer.insertSublayer(gradientLayer, below: animationToShow?.layer)
        updateGradientLayerFrame()
    }
    
    private func updateGradientLayerFrame() {
        gradientLayer.frame = CGRect(
            origin: .zero,
            size: CGSize(width: view.bounds.width, height: view.bounds.height * (animationViewHeightMultiplier + 0.2))
        )
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
        let action = #selector(handleTyping)
        textInputView.addTarget(self, action: action, for: .editingChanged)
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
    
    private func configureMessagesTableView() {
            messagesTableView = UITableView()
            messagesTableView.delegate = self
            messagesTableView.dataSource = self
            messagesTableView.separatorStyle = .none
            messagesTableView.backgroundColor = .clear
            messagesTableView.translatesAutoresizingMaskIntoConstraints = false
            messagesTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
            view.addSubview(messagesTableView)
            NSLayoutConstraint.activate([
                messagesTableView.topAnchor.constraint(equalTo: idleAnimationView.bottomAnchor, constant: 10),
                messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                messagesTableView.bottomAnchor.constraint(equalTo: textInputView.topAnchor, constant: -10)
            ])
            // Otomatik boyutlandırma ayarları
            messagesTableView.rowHeight = UITableView.automaticDimension
            messagesTableView.estimatedRowHeight = 50
        }
    
    private func configureTapGesture() {
        let action = #selector(handleTap)
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helpers
    
    private func processGreetingMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            speakText(greetingMessage)
            addMessage(Message(text: greetingMessage, isFrom: .ai))
        }
    }
    
    private func speakText(_ text: String) {
        // Stop if talking
        speechSynthesizer.stopSpeaking(at: .immediate)
        // Create AVSpeechUtterance to speak
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5 // Speech speed rate
        utterance.pitchMultiplier = 0.5
        utterance.preUtteranceDelay = 0
        utterance.volume = 1
        if let language = self.detectLanguageOf(text: text) {
            let voice = AVSpeechSynthesisVoice(language: language.rawValue)
            utterance.voice = voice
        }
        // Konuşma işlemini başlat
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
    }
    
    private func detectLanguageOf(text: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        guard let language = recognizer.dominantLanguage else { return nil}
        return language
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
    
    private func addMessage(_ message: Message) {
        messages.append(message)
        messagesTableView.reloadData()
        messagesTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    // MARK: - Switch Animation View Based on State
    
    private func updateAnimation(for state: AnimationState) {
        guard state != oldAnimationState else { return }
        // Hide all animations first
        listeningAnimationView.isHidden = true
        idleAnimationView.isHidden = true
        typingAnimationView.isHidden = true
        typingALotAnimationView.isHidden = true
        
        // Show and play the relevant animation
        switch state {
        case .listening:
            animationToShow = listeningAnimationView
        case .idle:
            animationToShow = idleAnimationView
        case .typing:
            animationToShow = typingAnimationView
        case .typingALot:
            animationToShow = typingALotAnimationView
        }
        
        animationToShow!.isHidden = false
        animationToShow!.play()
        // Update old state
        oldAnimationState = state
    }
    
    private func updateSendButtonState(isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        updateAnimation(for: .listening)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        guard let animationToShow else { return }
        animationToShow.pause()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        guard let animationToShow else { return }
        animationToShow.play()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        updateAnimation(for: .idle)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        updateAnimation(for: .idle)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.sendButton) == true {
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @objc
    private func handleButtonPress(_ sender: UIButton) {
        if isKeyboardVisible { view.endEditing(true) }
        guard let text = textInputView.text else { return }
        addMessage(Message(text: text, isFrom: isFromUser ? .user : .ai))
        // Only read ai responses
        if !isFromUser { speakText(text) }
        isFromUser.toggle()
        textInputView.text = nil
        updateSendButtonState(isEnabled: false)
    }
    
    @objc
    private func handleTap() {
        if isKeyboardVisible { view.endEditing(true) }
    }
    
    @objc
    private func handleTyping() {
        let text = textInputView.text ?? ""
        // Determine if the user is typing a lot
        let typingState: AnimationState = text.count > 50 ? .typingALot : .typing
        updateAnimation(for: typingState)
        // Enable/disable the send button based on text content
        updateSendButtonState(isEnabled: !text.isEmpty)
        if text.isEmpty {
            updateAnimation(for: .idle)
        }
    }
}
