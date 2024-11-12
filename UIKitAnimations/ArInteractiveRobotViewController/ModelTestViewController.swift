//
//  ModelTestViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 12.11.2024.
//

import UIKit
import SceneKit

// Displaying model parts into single struct,
// makes it easier to control nodes
struct Character {
    var jaw: SCNNode?
    var eyes: SCNNode?
    var lips: Lips?
}

// This class contains SCNNode and it's original position
// `originalPosition` will be used for resetting position
// of the node after animations
class LipPartNode: SCNNode {
    var node: SCNNode?
    var originalPosition: SCNVector3?
    init(node: SCNNode? = nil) {
        self.node = node
        self.originalPosition = self.node?.position
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Displaying model lip parts, this model has 6
// nodes for lip so top[left, center, right] bottom[left, center, right]
// so collecting them into single struct makes it easier to control child nodes
struct LipPart {
    var center: LipPartNode?
    var right: LipPartNode?
    var left: LipPartNode?
    var asArray: Array<LipPartNode?> = []
    init(center: LipPartNode? = nil, right: LipPartNode? = nil, left: LipPartNode? = nil) {
        self.center = center
        self.right = right
        self.left = left
        self.asArray = [left, center, right]
    }
}

struct Lips {
    var upperPart: LipPart?
    var lowerPart: LipPart?
}

class ModelTestViewController: BaseViewController {
    
    var sceneView: SCNView!
    var modelRootNode: SCNNode?
    var character: Character!
    
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
        configureSceneView()
        configure3Dmodel(named: "handsomeGuy.scn")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateTalking()
        }
    }
    
    private func configureNavigationBar() {
        tintColor = .black
        hasBackButton = true
    }
    
    private func configureSceneView() {
        sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        // Create scene and assign it to sceneView
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = false // Kamera kontrolünü etkinleştir (modeli döndürmek ve yakınlaştırmak için)
        sceneView.backgroundColor = UIColor.black // Arka plan rengi
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
        character = setupCharacterNodes(characterNode: modelRootNode!)
        
        printNodeNamesRecursive(node: modelRootNode!)
    }
    
    private func setupCamera(to scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 8, z: 90)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func setupCharacterNodes(characterNode: SCNNode) -> Character {
        let jaw = characterNode.childNode(withName: "jaw", recursively: true)
        let eyes = characterNode.childNode(withName: "Eyes", recursively: true)
        let lipDown = characterNode.childNode(withName: "LipDown", recursively: true)
        let lipDownR = characterNode.childNode(withName: "LipDown_R", recursively: true)
        let lipDownL = characterNode.childNode(withName: "LipDown_L", recursively: true)
        let lipUp = characterNode.childNode(withName: "LipUp", recursively: true)
        let lipUpR = characterNode.childNode(withName: "LipUp_R", recursively: true)
        let lipUpL = characterNode.childNode(withName: "LipUp_L", recursively: true)
        
        return Character(
            jaw: jaw,
            eyes: eyes,
            lips: Lips(
                upperPart: LipPart(
                    center: LipPartNode(node: lipUp),
                    right: LipPartNode(node: lipUpR),
                    left: LipPartNode(node: lipUpL)
                ),
                lowerPart: LipPart(
                    center: LipPartNode(node: lipDown),
                    right: LipPartNode(node: lipDownR),
                    left: LipPartNode(node: lipDownL)
                )
            )
        )
    }
    
    // MARK: - Animations
    
    func animateJawOpen(jaw: SCNNode, duration: TimeInterval) {
        let openAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.4, z: 0.0), duration: duration)
        jaw.runAction(openAction)
    }

    func animateJawClose(jaw: SCNNode, duration: TimeInterval) {
        let closeAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.1, z: 0.0), duration: duration)
        jaw.runAction(closeAction)
    }
        
    // Animate a wide mouth shape (for sounds like “A” or “E”)
    func animateCharacterWideMouth(duration: TimeInterval) {
        guard let upperLip = character.lips?.upperPart,
              let lowerLip = character.lips?.lowerPart  else {
            return
        }
        
        let moveUpAction = SCNAction.move(
            to: SCNVector3(
                x: upperLip.center!.position.x,
                y: upperLip.center!.position.y + 0.05,
                z: upperLip.center!.position.z
            ),
            duration: duration
        )
        let moveDownAction = SCNAction.move(
            to: SCNVector3(
                x: lowerLip.center!.position.x,
                y: lowerLip.center!.position.y + 0.05,
                z: lowerLip.center!.position.z
            ),
            duration: duration
        )
        upperLip.asArray.compactMap({ $0 }).forEach({ $0.runAction(moveUpAction) })
        lowerLip.asArray.compactMap({ $0 }).forEach({ $0.runAction(moveDownAction) })
    }
    
    // Rounded mouth shape (e.g., “O” or “U”)
    func animateRoundedMouth(lipUp: SCNNode, lipDown: SCNNode, duration: TimeInterval) {
        let moveUpAction = SCNAction.move(to: SCNVector3(x: 0.05, y: lipUp.position.y, z: 0.05), duration: duration)
        let moveDownAction = SCNAction.move(to: SCNVector3(x: -0.05, y: lipDown.position.y, z: 0.05), duration: duration)
        
        lipUp.runAction(moveUpAction)
        lipDown.runAction(moveDownAction)
    }
    
    // Closed mouth shape (e.g., “M”)
    func animateClosedMouth(lipUp: SCNNode, lipDown: SCNNode, duration: TimeInterval) {
        let moveUpAction = SCNAction.move(to: SCNVector3(x: 0.0, y: lipUp.position.y, z: lipUp.position.z), duration: duration)
        let moveDownAction = SCNAction.move(to: SCNVector3(x: 0.0, y: lipDown.position.y, z: lipDown.position.z), duration: duration)
        
        lipUp.runAction(moveUpAction)
        lipDown.runAction(moveDownAction)
    }
    
    // Return nodes to original positions
    func resetMouthShape() {
        guard let upperLip = character.lips?.lowerPart,
              let lowerLip = character.lips?.lowerPart  else {
            return
        }
        upperLip.asArray.compactMap({ $0 }).forEach({ $0.position = $0.originalPosition! })
        lowerLip.asArray.compactMap({ $0 }).forEach({ $0.position = $0.originalPosition! })
    }

    // MARK: - Actions

    func animateLipSync(characterNode: SCNNode, visemes: [String], durations: [Double]) {
        
        var delay: TimeInterval = 0.0
        
        for (index, viseme) in visemes.enumerated() {
            let duration = durations[index]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self else { return }
                switch viseme {
                case "A": // Wide mouth
                    animateJawOpen(jaw: character.jaw!, duration: duration)
                    animateCharacterWideMouth(duration: duration)
                case "O": // Rounded mouth
                    animateJawOpen(jaw: character.jaw!, duration: duration)
//                    animateRoundedMouth(lipUp: bones.lipUp!, lipDown: bones.lipDown!, duration: duration)
                case "M": // Closed mouth
                    animateJawClose(jaw: character.jaw!, duration: duration)
//                    animateClosedMouth(lipUp: bones.lipUp!, lipDown: bones.lipDown!, duration: duration)
                default:
                    break
                }
                // Optionally reset after each duration to neutral state
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                    guard let self else { return }
                    resetMouthShape()
                    animateJawClose(jaw: character.jaw!, duration: 0.2)
                }
            }
            
            delay += duration
        }
    }

    func animateTalking() {
        guard let characterNode = modelRootNode else { return }
        animateLipSync(
            characterNode: characterNode,
            visemes: [
                "A", "O", "M", "A", "O", "M", "A", "O", "M"
            ],
            durations: [
                0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3
            ]
        )
    }
}

// MARK: - Helpers

extension ModelTestViewController {
    
    func printNodeNames(forNode modelNode: SCNNode?) {
        guard let modelNode = modelNode else { return }
        printNodeNamesRecursive(node: modelNode)
    }
    
    func printNodeNamesRecursive(node: SCNNode) {
        print("Node Name: \(node.name ?? "Unnamed")")
        for childNode in node.childNodes {
            printNodeNamesRecursive(node: childNode)
        }
    }
}
