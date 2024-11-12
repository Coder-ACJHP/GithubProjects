//
//  InteractiveRobotViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 6.11.2024.
//

import UIKit
import SceneKit
import AVFoundation

class InteractiveRobotViewController: BaseViewController {
    
    var sceneView: SCNView!
    let speechSynthesizer = AVSpeechSynthesizer() // Konuşma için synthesizer
    var modelNode: SCNNode?
    var model2Node: SCNNode?
    var leftEye: SCNNode?
    var rightEye: SCNNode?
    var bodyNode: SCNNode?
    var geomNode: SCNNode?
    var animationPlayer: SCNAnimationPlayer? = nil
    var animations = [String: CAAnimation]()
    
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
        // Create SCNView
        sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Create scene and assign it to sceneView
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = false // Kamera kontrolünü etkinleştir (modeli döndürmek ve yakınlaştırmak için)
        sceneView.backgroundColor = UIColor.black // Arka plan rengi
        sceneView.autoenablesDefaultLighting = true
        
        // Add 3D model here
        add3DModel()
        
        printNodeNamesRecursive(node: modelNode!)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 9, z: 50)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateEyeBlink()
        animateBodyLookAround()
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    func add3DModel() {
        // Load model file from the bundle
        
        // 1 - Load without options anmiation policy
//        guard let modelScene = SCNScene(named: "art.scnassets/Talking.usdz") else {
//            print("Model yüklenemedi.")
//            return
//        }
//        
//        guard let model2Scene = SCNScene(named: "art.scnassets/Talking_2.usdz") else {
//            print("Model yüklenemedi.")
//            return
//        }

//        modelNode = modelScene.rootNode
//        modelNode?.position = SCNVector3(0, 0, 0)
//        modelNode?.scale = SCNVector3(0.1, 0.1, 0.1) // Model boyutunu ayarla
//        modelNode?.opacity = 1.0
//        sceneView.scene?.rootNode.addChildNode(modelNode!)
//        
//        
//        model2Node = model2Scene.rootNode
//        model2Node?.position = SCNVector3(0, 0, 0)
//        model2Node?.scale = SCNVector3(0.1, 0.1, 0.1)
//        model2Node?.opacity = 0.0
//        sceneView.scene?.rootNode.addChildNode(model2Node!)
        
        guard let scene = SCNScene(named: "art.scnassets/riggedFaceScn.scn") else {
            return print("Model yüklenemedi.")
        }
        modelNode = scene.rootNode.clone()
        modelNode?.position = SCNVector3(0, 0, 0)
        modelNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        sceneView.scene?.rootNode.addChildNode(modelNode!)
        
        bodyNode = modelNode?.childNode(withName: "riggedFace", recursively: true)
        leftEye = modelNode?.childNode(withName: "Eye1", recursively: true)
        rightEye = modelNode?.childNode(withName: "Eye2", recursively: true)
        geomNode = modelNode?.childNode(withName: "Body", recursively: true)
        
        if let material = geomNode?.geometry?.firstMaterial {
            material.diffuse.contents = UIColor.red // Change to red color
        }
    }
    
    func playAnimation(key: String) {
        guard animations.isEmpty == false else { return print("No animations") }
        sceneView.scene?.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func loadAnimation(withKey: String, sceneName: String, animationIdentifier: String) {

        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)

        if let animationObj = sceneSource?.entryWithIdentifier(animationIdentifier,
                                                     withClass: CAAnimation.self) {
            animationObj.repeatCount = 1
            animationObj.fadeInDuration = CGFloat(1)
            animationObj.fadeOutDuration = CGFloat(0.5)

            animations[withKey] = animationObj
        }
    }
    
    func speakText(_ text: String) {
        // Create AVSpeechUtterance to speak
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR") // Türkçe konuşma
        utterance.rate = 0.5 // Speech speed rate
        
        // Konuşma işlemini başlat
        speechSynthesizer.speak(utterance)
    }
    
    func printNodeNames(forNode modelNode: SCNNode?) {
        guard let modelNode = modelNode else { return }
        
        printNodeNamesRecursive(node: modelNode)
    }
    
    func printNodeNamesRecursive(node: SCNNode) {
        // Node adını yazdır
        print("Node Name: \(node.name ?? "Unnamed")")
        
        // Çocuk node'larını tekrarla
        for childNode in node.childNodes {
            printNodeNamesRecursive(node: childNode)
        }
    }
    
    // Start head animation (shrink auto reverse)
    func animateEyeBlink() {
        guard let leftEye, let rightEye else { return }
        leftEye.pivot = SCNMatrix4MakeTranslation(0, -1, 0)
        leftEye.pivot = SCNMatrix4MakeTranslation(0, -1, 0)
        
        let closeEyes = SCNAction.scale(to: 0.6, duration: 0.5)
        closeEyes.timingMode = .easeIn
        
        let openEyes = SCNAction.scale(to: 1.0, duration: 0.5)
        openEyes.timingMode = .easeOut
            
        let blinkAction = SCNAction.sequence([
            closeEyes,
            openEyes,
            closeEyes,
            openEyes
        ])
        
        let delayAction = SCNAction.wait(duration: 3.0)
        let blinkSequence = SCNAction.sequence([blinkAction, delayAction])
        let repeatBlinkAction = SCNAction.repeatForever(blinkSequence)
        repeatBlinkAction.timingMode = .easeInEaseOut
        leftEye.runAction(repeatBlinkAction)
        rightEye.runAction(repeatBlinkAction)
    }
    
    func animateBodyLookAround() {
        guard let bodyNode else { return }
        
        // Define smoother, more subtle rotation actions for idle "look around"
        let lookLeft = SCNAction.rotateBy(x: 0, y: .pi / 12, z: 0, duration: 1.2)  // Subtle look left
        lookLeft.timingMode = .easeInEaseOut
        
        let lookRight = SCNAction.rotateBy(x: 0, y: -.pi / 8, z: 0, duration: 1.4) // Subtle look right
        lookRight.timingMode = .easeInEaseOut
        
        let lookDown = SCNAction.rotateBy(x: .pi / 20, y: 0, z: 0, duration: 1.2)   // Subtle tilt up
        lookDown.timingMode = .easeInEaseOut
        
        let lookUp = SCNAction.rotateBy(x: -.pi / 20, y: 0, z: 0, duration: 1.2)  // Subtle tilt down
        lookUp.timingMode = .easeInEaseOut
        
        // Slight forward tilt to make it appear as a more relaxed posture
        let slightForwardTilt = SCNAction.rotateBy(x: .pi / 40, y: 0, z: 0, duration: 1.2)
        slightForwardTilt.timingMode = .easeInEaseOut
        
        // Return to a neutral, forward-looking position
        let resetPosition = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 1.2)
        resetPosition.timingMode = .easeInEaseOut
        
        // Sequence of movements with varied pauses for natural feel
        let lookSequence = SCNAction.sequence([
            slightForwardTilt,
            SCNAction.wait(duration: 1.0),
            lookLeft,
            SCNAction.wait(duration: 0.6),
            lookRight,
            SCNAction.wait(duration: 0.8),
            resetPosition,
            SCNAction.wait(duration: 0.5),
            lookDown,
            SCNAction.wait(duration: 0.7),
            lookDown,
            SCNAction.wait(duration: 0.9),
            resetPosition,
            SCNAction.wait(duration: 5.0)  // Longer pause at neutral position to simulate idle state
        ])
        
        // Repeat the sequence indefinitely for idle animation
        let repeatLookAround = SCNAction.repeatForever(lookSequence)
        
        // Run the action on the body node
        bodyNode.runAction(repeatLookAround)
    }


}
