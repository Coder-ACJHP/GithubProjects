//
//  InteractiveRobotViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 6.11.2024.
//

import UIKit
import SceneKit
import AVFoundation

class InteractiveRobotViewController: UIViewController {
    
    var sceneView: SCNView!
    let speechSynthesizer = AVSpeechSynthesizer() // Konuşma için synthesizer
    var modelNode: SCNNode?
    var faceNode: SCNNode? // Yüz kısmı için özel node (bunu modelinizin yüzüyle değiştirebilirsiniz)
    var animationPlayer: SCNAnimationPlayer? = nil
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create SCNView
        sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Create scene and assign it to sceneView
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true // Kamera kontrolünü etkinleştir (modeli döndürmek ve yakınlaştırmak için)
        sceneView.backgroundColor = UIColor.gray // Arka plan rengi
        sceneView.autoenablesDefaultLighting = true
        
        // Add 3D model here
        add3DModel()
        
        // Add a camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 9, z: 20)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Modeli konuştur ve yüz animasyonunu başlat
        speakText("Merhaba! Ben bir 3D modelim, şimdi kafamı şişiriyorum.")
        animateFace()
    }
    func add3DModel() {
        // Load model file from the bundle
        
        // 1 - Load without options anmiation policy
//        guard let modelScene = SCNScene(named: "art.scnassets/Talking.usdz") else {
//            print("Model yüklenemedi.")
//            return
//        }
        
        // Load with animation policy
        guard let modelURL = Bundle.main.url(forResource: "art.scnassets/Talking", withExtension: "usdz"),
              let modelScene = try? SCNScene(url: modelURL, options: [.animationImportPolicy : SCNSceneSource.AnimationImportPolicy.playUsingSceneTimeBase ]) else {
            print("Model yüklenemedi.")
            return
        }
        
        // Get root node and adjust it's position and scale
        modelNode = modelScene.rootNode
        modelNode?.position = SCNVector3(0, 0, 0)
        modelNode?.scale = SCNVector3(0.1, 0.1, 0.1) // Model boyutunu ayarla
        
        // Add model to scene
        if let modelNode = modelNode {
            sceneView.scene?.rootNode.addChildNode(modelNode)
            // For example get head node to play with it
            faceNode = modelNode.childNode(withName: "mixamorig_Head", recursively: true)
        }
        
        printNodeNames()
    }
    
    func speakText(_ text: String) {
        // Create AVSpeechUtterance to speak
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR") // Türkçe konuşma
        utterance.rate = 0.5 // Speech speed rate
        
        // Konuşma işlemini başlat
        speechSynthesizer.speak(utterance)
    }
    
    func printNodeNames() {
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
    func animateFace() {
        guard let faceNode = faceNode else { return }
    
        let blinkAction = SCNAction.sequence([
            SCNAction.scale(to: 0.9, duration: 0.1),
            SCNAction.scale(to: 1.0, duration: 0.1)
        ])
        
        let repeatBlinkAction = SCNAction.repeatForever(blinkAction)
        faceNode.runAction(repeatBlinkAction)
    }
}
