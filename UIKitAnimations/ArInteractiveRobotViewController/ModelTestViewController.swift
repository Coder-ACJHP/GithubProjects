//
//  ModelTestViewController.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 12.11.2024.
//

import UIKit
import SceneKit

class ModelTestViewController: BaseViewController {
    
    enum State {
        case talking, idle, none
    }
    
    var sceneView: SCNView!
    var modelRootNode: SCNNode?
    
    // Nodes
    var jaw: SCNNode?
    var jawOrigin: SCNVector3?
    var eyes: SCNNode?
    var eyesOrigin: SCNVector3?
    var lipUpL: SCNNode?
    var lipUpLOrigin: SCNVector3?
    var lipUp: SCNNode?
    var lipUpOrigin: SCNVector3?
    var lipUpR: SCNNode?
    var lipUpROrigin: SCNVector3?
    var lipDownL: SCNNode?
    var lipDownLOrigin: SCNVector3?
    var lipDown: SCNNode?
    var lipDownOrigin: SCNVector3?
    var lipDownROrigin: SCNVector3?
    var lipDownR: SCNNode?
    var sideLipL: SCNNode?
    var sideLipLOrigin: SCNVector3?
    var sideLipR: SCNNode?
    var sideLipROrigin: SCNVector3?    
    var eyeLidUpR: SCNNode?
    var eyeLidUpROrigin: SCNVector3?
    var eyeLidUpL: SCNNode?
    var eyeLidUpLOrigin: SCNVector3?
    var eyeLidDownL: SCNNode?
    var eyeLidDownLOrigin: SCNVector3?
    var eyeLidDownR: SCNNode?
    var eyeLidDownROrigin: SCNVector3?
    // Head
    var head: SCNNode?
    var headOrigin: SCNVector3?
    
    // Timer
    private var idleStateTimer: Timer?
    private var currentState: State = .none {
        didSet {
            print("State: \(currentState)")
        }
    }
    
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

//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let self else { return }
//            startIdleStateAnimation()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.animateTalking()
//            }
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animateTalking()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBlinkRandomizeTimer()
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
        loadReuiredNodes(from: modelRootNode)
    }
    
    private func setupCamera(to scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 8, z: 90)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func loadReuiredNodes(from rootNode: SCNNode?) {
        guard let characterNode = rootNode else { return  }
        // Face Parts
        // 1 - Jaw
        jaw = characterNode.childNode(withName: "jaw", recursively: true)
        jawOrigin = jaw?.position
        // 2 - Eyes
        eyes = characterNode.childNode(withName: "Eyes", recursively: true)
        eyesOrigin = eyes?.position
        // 3 - Lips
        lipDown = characterNode.childNode(withName: "LipDown", recursively: true)
        lipDownOrigin = lipDown?.position
        lipDownR = characterNode.childNode(withName: "LipDown_R", recursively: true)
        lipDownROrigin = lipDownR?.position
        lipDownL = characterNode.childNode(withName: "LipDown_L", recursively: true)
        lipDownLOrigin = lipDownL?.position
        lipUp = characterNode.childNode(withName: "LipUp", recursively: true)
        lipUpOrigin = lipUp?.position
        lipUpR = characterNode.childNode(withName: "LipUp_R", recursively: true)
        lipUpROrigin = lipUpR?.position
        lipUpL = characterNode.childNode(withName: "LipUp_L", recursively: true)
        lipUpLOrigin = lipUpL?.position
        sideLipL = characterNode.childNode(withName: "SideLip_L", recursively: true)
        sideLipLOrigin = sideLipL?.position
        sideLipR = characterNode.childNode(withName: "SideLip_R", recursively: true)
        sideLipROrigin = sideLipR?.position
        // 4 - Eyelid
        eyeLidUpL = characterNode.childNode(withName: "UpLid_L", recursively: true)
        eyeLidUpLOrigin = eyeLidUpL?.position
        eyeLidUpR = characterNode.childNode(withName: "UpLid_R", recursively: true)
        eyeLidUpROrigin = eyeLidUpR?.position
        eyeLidDownL = characterNode.childNode(withName: "DownLid_L", recursively: true)
        eyeLidDownLOrigin = eyeLidDownL?.position
        eyeLidDownR = characterNode.childNode(withName: "DownLid_R", recursively: true)
        eyeLidDownROrigin = eyeLidDownR?.position
        // 5 - Head
        head = characterNode.childNode(withName: "head", recursively: true)
        headOrigin = head?.position
    }
    
    // MARK: - Talking Animations
    
    func animateJawOpen(jaw: SCNNode, power: Float = -0.3, duration: TimeInterval) {
        let openAction = SCNAction.move(to: SCNVector3(x: 0, y: power, z: 0.0), duration: duration)
        jaw.runAction(openAction)
    }

    func animateJawClose(duration: TimeInterval) {
        guard let jaw else { return }
        let closeAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.1, z: 0.0), duration: duration)
        jaw.runAction(closeAction)
    }
        
    // Wide open mouth. This mouth shapes is used for vowels like "AA" as in father.
    func animateWiderMouth(duration: TimeInterval) {
        animateWideMouth(basePower: 0.03, duration: duration)
    }
    /* 
     Open mouth. This mouth shape is used for vowels like "EH" as in men and "AE" as in bat.
     It's also used for some consonants, depending on context.
    */
    func animateWideMouth(basePower power: Float = 0.02, duration: TimeInterval) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipDownL, let lipDown, let lipDownR,
              let jaw
        else {
            return print("Required lip nodes not found")
        }
        
        animateJawOpen(jaw: jaw, power: -0.3, duration: duration)

        // Upper lip parts: Moving slightly upward and outward
        let upperLeftAction = SCNAction.move(to: SCNVector3(
            x: lipUpL.position.x - 0.05,
            y: lipUpL.position.y + power,
            z: lipUpL.position.z
        ), duration: duration)
        
        let upperCenterAction = SCNAction.move(to: SCNVector3(
            x: lipUp.position.x,
            y: lipUp.position.y + (power + 0.01),
            z: lipUp.position.z
        ), duration: duration)
        
        let upperRightAction = SCNAction.move(to: SCNVector3(
            x: lipUpR.position.x + 0.05,
            y: lipUpR.position.y + power,
            z: lipUpR.position.z
        ), duration: duration)

        // Lower lip parts: Moving slightly downward and outward
        let lowerLeftAction = SCNAction.move(to: SCNVector3(
            x: lipDownL.position.x - 0.05,
            y: lipDownL.position.y + power,
            z: lipDownL.position.z
        ), duration: duration)
        
        let lowerCenterAction = SCNAction.move(to: SCNVector3(
            x: lipDown.position.x,
            y: lipDown.position.y + (power + 0.01),
            z: lipDown.position.z
        ), duration: duration)
        
        let lowerRightAction = SCNAction.move(to: SCNVector3(
            x: lipDownR.position.x + 0.05,
            y: lipDownR.position.y + power,
            z: lipDownR.position.z
        ), duration: duration)

        // Run actions for upper lip nodes
        lipUpL.runAction(upperLeftAction)
        lipUp.runAction(upperCenterAction)
        lipUpR.runAction(upperRightAction)

        // Run actions for lower lip nodes
        lipDownL.runAction(lowerLeftAction)
        lipDown.runAction(lowerCenterAction)
        lipDownR.runAction(lowerRightAction)
    }
    
    /*
     Slightly rounded mouth. This mouth shape is used for vowels like
     "AO" as in off and "ER" as in bird.
     This shape is also used as an in-between when animating from © or O to ©.
     Make sure the mouth isn't wider open than for ©. Both ©©@ and O©© should result in smooth animation.
     */
    func animateRoundedMouth(duration: TimeInterval) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipDownL, let lipDown, let lipDownR,
              let sideLipL, let sideLipR,
              let jaw
        else {
            return print("Required lip nodes not found")
        }
        
        animateJawOpen(jaw: jaw, power: -0.2, duration: duration)

        // Upper lip parts: Move more dramatically inward and upward
        let upperLeftAction = SCNAction.move(to: SCNVector3(
            x: lipUpL.position.x - 0.05,
            y: lipUpL.position.y + 0.03,
            z: lipUpL.position.z
        ), duration: duration)
        
        let upperCenterAction = SCNAction.move(to: SCNVector3(
            x: lipUp.position.x,
            y: lipUp.position.y + 0.06,
            z: lipUp.position.z
        ), duration: duration)
        
        let upperRightAction = SCNAction.move(to: SCNVector3(
            x: lipUpR.position.x + 0.05,
            y: lipUpR.position.y + 0.03,
            z: lipUpR.position.z
        ), duration: duration)

        // Lower lip parts: Move inward and **upward** more dramatically
        let lowerLeftAction = SCNAction.move(to: SCNVector3(
            x: lipDownL.position.x + 0.05,
            y: lipDownL.position.y + 0.03,
            z: lipDownL.position.z
        ), duration: duration)
        
        let lowerCenterAction = SCNAction.move(to: SCNVector3(
            x: lipDown.position.x,
            y: lipDown.position.y + 0.06,
            z: lipDown.position.z
        ), duration: duration)
        
        let lowerRightAction = SCNAction.move(to: SCNVector3(
            x: lipDownR.position.x - 0.05,
            y: lipDownR.position.y + 0.03,
            z: lipDownR.position.z
        ), duration: duration)

        // Side lip parts: Moving further inward for a stronger rounded effect
        let sideLeftAction = SCNAction.move(to: SCNVector3(
            x: sideLipL.position.x + 0.06,
            y: sideLipL.position.y,
            z: sideLipL.position.z
        ), duration: duration)

        let sideRightAction = SCNAction.move(to: SCNVector3(
            x: sideLipR.position.x - 0.06,
            y: sideLipR.position.y,
            z: sideLipR.position.z
        ), duration: duration)

        // Run actions for upper lip nodes
        lipUpL.runAction(upperLeftAction)
        lipUp.runAction(upperCenterAction)
        lipUpR.runAction(upperRightAction)

        // Run actions for lower lip nodes
        lipDownL.runAction(lowerLeftAction)
        lipDown.runAction(lowerCenterAction)
        lipDownR.runAction(lowerRightAction)
        
        // Run actions for side lip nodes
        sideLipL.runAction(sideLeftAction)
        sideLipR.runAction(sideRightAction)
    }
    
    private func resetMouthShape(duration: TimeInterval = 0.5) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipUpLOrigin, let lipUpOrigin, let lipUpROrigin,
              let lipDownL, let lipDown, let lipDownR,
              let lipDownLOrigin, let lipDownOrigin, let lipDownROrigin,
              let sideLipL, let sideLipR,
              let sideLipLOrigin, let sideLipROrigin
        else {
            return print("Required lip nodes not found")
        }
        let lipsList = [lipUpL, lipUp, lipUpR, lipDownL, lipDown, lipDownR, sideLipL, sideLipR]
        let lipsOriginList = [lipUpLOrigin, lipUpOrigin, lipUpROrigin, lipDownLOrigin, lipDownOrigin, lipDownROrigin, sideLipLOrigin, sideLipROrigin]
        for (index, node) in lipsList.enumerated() {
            node.runAction(reset(position: lipsOriginList[index], duration: duration))
        }
    }
    
    /*
     Closed mouth for the "P", "B", and "M" sounds. This is almost
     identical to the @ shape, but there is ever-so-slight pressure between the lips.
     */
    func animateClosedMouth(duration: TimeInterval) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipDownL, let lipDown, let lipDownR
        else {
            return print("Required lip nodes not found")
        }
        
        // Upper lip parts: Move inward and downward slightly to close the mouth
        let upperLeftAction = SCNAction.move(to: SCNVector3(
            x: lipUpL.position.x,
            y: lipUpL.position.y - 0.04,
            z: lipUpL.position.z
        ), duration: duration)
        
        let upperCenterAction = SCNAction.move(to: SCNVector3(
            x: lipUp.position.x,
            y: lipUp.position.y - 0.04,
            z: lipUp.position.z
        ), duration: duration)
        
        let upperRightAction = SCNAction.move(to: SCNVector3(
            x: lipUpR.position.x,
            y: lipUpR.position.y - 0.04,
            z: lipUpR.position.z
        ), duration: duration)

        // Lower lip parts: Move inward and upward to meet the upper lip
        let lowerLeftAction = SCNAction.move(to: SCNVector3(
            x: lipDownL.position.x,
            y: lipDownL.position.y - 0.04,
            z: lipDownL.position.z
        ), duration: duration)
        
        let lowerCenterAction = SCNAction.move(to: SCNVector3(
            x: lipDown.position.x,
            y: lipDown.position.y - 0.04,
            z: lipDown.position.z
        ), duration: duration)
        
        let lowerRightAction = SCNAction.move(to: SCNVector3(
            x: lipDownR.position.x,
            y: lipDownR.position.y - 0.04,
            z: lipDownR.position.z
        ), duration: duration)

        // Run actions for upper lip nodes
        lipUpL.runAction(upperLeftAction)
        lipUp.runAction(upperCenterAction)
        lipUpR.runAction(upperRightAction)

        // Run actions for lower lip nodes
        lipDownL.runAction(lowerLeftAction)
        lipDown.runAction(lowerCenterAction)
        lipDownR.runAction(lowerRightAction)
    }
    
    // MARK: - Blink animation

    private func startBlinkEyes(duration: TimeInterval) {
        resetBlinkRandomizeTimer()
        createBlinkRandomizeTimer(blinkDuration: duration)
    }
    
    // Function to create a random blink sequence with 1 or 2 blinks
    func createRandomBlinkSequence(count: Int, duration: TimeInterval) -> (SCNAction, SCNAction, SCNAction, SCNAction) {
        guard let eyeLidUpL, let eyeLidUpLOrigin, let eyeLidUpR, let eyeLidUpROrigin,
              let eyeLidDownL, let eyeLidDownLOrigin, let eyeLidDownR, let eyeLidDownROrigin else {
            return (SCNAction(), SCNAction(), SCNAction(), SCNAction())
        }
        
        let blinkCount = count
        var upperLidActionsL = [SCNAction]()
        var upperLidActionsR = [SCNAction]()
        var lowerLidActionsL = [SCNAction]()
        var lowerLidActionsR = [SCNAction]()
        
        for _ in 0..<blinkCount {
            let blinkUpperLeftLid = SCNAction.move(to: SCNVector3(
                x: eyeLidUpL.position.x,
                y: eyeLidUpL.position.y - 0.07,
                z: eyeLidUpL.position.z
            ), duration: duration)
            blinkUpperLeftLid.timingMode = .easeIn
            
            let blinkUpperRightLid = SCNAction.move(to: SCNVector3(
                x: eyeLidUpR.position.x,
                y: eyeLidUpR.position.y - 0.07,
                z: eyeLidUpR.position.z
            ), duration: duration)
            blinkUpperRightLid.timingMode = .easeIn
            
            let blinkLowerLeftLid = SCNAction.move(to: SCNVector3(
                x: eyeLidDownL.position.x,
                y: eyeLidDownL.position.y + 0.07,
                z: eyeLidDownL.position.z
            ), duration: duration)
            blinkLowerLeftLid.timingMode = .easeIn
            
            let blinkLowerRightLid = SCNAction.move(to: SCNVector3(
                x: eyeLidDownR.position.x,
                y: eyeLidDownR.position.y + 0.07,
                z: eyeLidDownR.position.z
            ), duration: duration)
            blinkLowerRightLid.timingMode = .easeIn
            
            let openUpperLeftLid = reset(position: eyeLidUpLOrigin, duration: duration)
            let openUpperRightLid = reset(position: eyeLidUpROrigin, duration: duration)
            let openLowerLeftLid = reset(position: eyeLidDownLOrigin, duration: duration)
            let openLowerRightLid = reset(position: eyeLidDownROrigin, duration: duration)
            
            // Add close-open actions to each lid sequence
            upperLidActionsL.append(blinkUpperLeftLid)
            upperLidActionsL.append(openUpperLeftLid)
            
            upperLidActionsR.append(blinkUpperRightLid)
            upperLidActionsR.append(openUpperRightLid)
            
            lowerLidActionsL.append(blinkLowerLeftLid)
            lowerLidActionsL.append(openLowerLeftLid)
            
            lowerLidActionsR.append(blinkLowerRightLid)
            lowerLidActionsR.append(openLowerRightLid)
            
            // Slight delay between double blinks
            let slightDelay = SCNAction.wait(duration: 0.1)
            upperLidActionsL.append(slightDelay)
            upperLidActionsR.append(slightDelay)
            lowerLidActionsL.append(slightDelay)
            lowerLidActionsR.append(slightDelay)
        }
        
        // Add a longer delay at the end of each full cycle
        let fullCycleDelay = SCNAction.wait(duration: 6.0)
        upperLidActionsL.append(fullCycleDelay)
        upperLidActionsR.append(fullCycleDelay)
        lowerLidActionsL.append(fullCycleDelay)
        lowerLidActionsR.append(fullCycleDelay)
        
        return (SCNAction.sequence(upperLidActionsL),
                SCNAction.sequence(upperLidActionsR),
                SCNAction.sequence(lowerLidActionsL),
                SCNAction.sequence(lowerLidActionsR))
    }
    
    // Create a repeating action for each eyelid with randomized blink cycles
    private func startBlinking(count: Int, duration: TimeInterval) {
        guard let eyeLidUpL, let eyeLidUpR,
              let eyeLidDownL, let eyeLidDownR else {
            return print("Required eyelid nodes not found")
        }
        let (upperLidActionL, upperLidActionR, lowerLidActionL, lowerLidActionR) = createRandomBlinkSequence(count: count, duration: duration)
        // Repeat forever with new randomized blink sequences in each cycle
        eyeLidUpL.runAction(SCNAction.repeatForever(upperLidActionL))
        eyeLidUpR.runAction(SCNAction.repeatForever(upperLidActionR))
        eyeLidDownL.runAction(SCNAction.repeatForever(lowerLidActionL))
        eyeLidDownR.runAction(SCNAction.repeatForever(lowerLidActionR))
    }
    
    private func stopBlinking() {
        guard let eyeLidUpL, let eyeLidUpR,
              let eyeLidDownL, let eyeLidDownR else {
            return print("Required eyelid nodes not found")
        }
        eyeLidUpL.removeAllActions()
        eyeLidUpR.removeAllActions()
        eyeLidDownL.removeAllActions()
        eyeLidDownR.removeAllActions()
    }

    
    private func createBlinkRandomizeTimer(blinkDuration duration: TimeInterval) {
        idleStateTimer = Timer.scheduledTimer(withTimeInterval: 9.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            // Stop old blink animations
            stopBlinking()
            // Create new randomized blink animation
            let blinkCount = Int.random(in: 1...2)
            startBlinking(count: blinkCount, duration: duration)
        })
        idleStateTimer?.fire()
    }
    
    private func resetBlinkRandomizeTimer() {
        if idleStateTimer != nil {
            idleStateTimer?.invalidate()
            idleStateTimer = nil
        }
    }
    
    // MARK: - Head Rotate Animation
    
    // Animate human idle state with head node
    private func startHeadRotateAnimation() {
        guard let head else { return }
        // Store the original orientation of the head
        let headOriginAngles = head.eulerAngles
        
        // Function to create a random head movement sequence
        func createHeadMovementSequence() -> SCNAction {
            // Define small rotation angles for slight movement
            let randomAngleX = Float.random(in: -0.05...0.05)  // Horizontal movement
            let randomAngleY = Float.random(in: -0.05...0.05)  // Vertical movement
            // Create slight rotation actions
            let rotateLeftRight = SCNAction.rotateBy(x: CGFloat(randomAngleX), y: CGFloat(randomAngleY), z: 0, duration: 1.0)
            let returnToOrigin = SCNAction.rotateTo(
                x: CGFloat(headOriginAngles.x),
                y: CGFloat(headOriginAngles.y),
                z: CGFloat(headOriginAngles.z),
                duration: 1.0
            )
            // Delay between movements to avoid constant rotation
            let slightDelay = SCNAction.wait(duration: 1.5)
            // Sequence: slight movement -> delay -> return to origin -> delay
            return SCNAction.sequence([rotateLeftRight, slightDelay, returnToOrigin, slightDelay])
        }
        
        // Recursive function to loop idle animation
        func runIdleHeadAnimation() {
            let headMovementSequence = createHeadMovementSequence()
            // Run sequence and repeat for continuous idle animation
            head.runAction(headMovementSequence) {
                runIdleHeadAnimation() // Recursively call for ongoing idle animation
            }
        }
        // Start the first idle head animation cycle
        runIdleHeadAnimation()
    }

    private func stopHeadRotateAnimation() {
        guard let head else { return }
        head.removeAllActions()
    }
    
    // MARK: - Smile Animation
    
    // Slight smile animation
    private func createSlightlySmileAnimation(duration: TimeInterval) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipDownL, let lipDown, let lipDownR,
              let sideLipL, let sideLipR
        else { return }
        
        let smileDuration = duration
        
        // Slight smile movement (mild lip movement)
        let smileUpperLipLeft = SCNAction.move(to: SCNVector3(x: lipUpL.position.x, y: lipUpL.position.y + 0.02, z: lipUpL.position.z), duration: smileDuration)
        let smileUpperLipCenter = SCNAction.move(to: SCNVector3(x: lipUp.position.x, y: lipUp.position.y + 0.03, z: lipUp.position.z), duration: smileDuration)
        let smileUpperLipRight = SCNAction.move(to: SCNVector3(x: lipUpR.position.x, y: lipUpR.position.y + 0.02, z: lipUpR.position.z), duration: smileDuration)
        
        let smileLowerLipLeft = SCNAction.move(to: SCNVector3(x: lipDownL.position.x, y: lipDownL.position.y - 0.02, z: lipDownL.position.z), duration: smileDuration)
        let smileLowerLipCenter = SCNAction.move(to: SCNVector3(x: lipDown.position.x, y: lipDown.position.y - 0.02, z: lipDown.position.z), duration: smileDuration)
        let smileLowerLipRight = SCNAction.move(to: SCNVector3(x: lipDownR.position.x, y: lipDownR.position.y - 0.02, z: lipDownR.position.z), duration: smileDuration)
        
        let smileSideLipLeft = SCNAction.move(to: SCNVector3(x: sideLipL.position.x - 0.02, y: sideLipL.position.y, z: sideLipL.position.z), duration: smileDuration)
        let smileSideLipRight = SCNAction.move(to: SCNVector3(x: sideLipR.position.x + 0.02, y: sideLipR.position.y, z: sideLipR.position.z), duration: smileDuration)
        
        lipUpL.runAction(smileUpperLipLeft)
        lipUp.runAction(smileUpperLipCenter)
        lipUpR.runAction(smileUpperLipRight)
        
        lipDownL.runAction(smileLowerLipLeft)
        lipDown.runAction(smileLowerLipCenter)
        lipDownR.runAction(smileLowerLipRight)
        
        sideLipL.runAction(smileSideLipLeft)
        sideLipR.runAction(smileSideLipRight)
    }

    // Strong smile animation
    private func createStrongSmileAnimation(duration smileDuration: TimeInterval = 1.0) {
        guard let lipUpL, let lipUp, let lipUpR,
              let lipDownL, let lipDown, let lipDownR,
              let sideLipL, let sideLipR
        else { return }
                
        // Stronger smile movement (larger lip movement)
        let smileUpperLipLeft = SCNAction.move(to: SCNVector3(x: lipUpL.position.x, y: lipUpL.position.y + 0.05, z: lipUpL.position.z), duration: smileDuration)
        let smileUpperLipCenter = SCNAction.move(to: SCNVector3(x: lipUp.position.x, y: lipUp.position.y + 0.07, z: lipUp.position.z), duration: smileDuration)
        let smileUpperLipRight = SCNAction.move(to: SCNVector3(x: lipUpR.position.x, y: lipUpR.position.y + 0.05, z: lipUpR.position.z), duration: smileDuration)
        
        let smileLowerLipLeft = SCNAction.move(to: SCNVector3(x: lipDownL.position.x, y: lipDownL.position.y - 0.05, z: lipDownL.position.z), duration: smileDuration)
        let smileLowerLipCenter = SCNAction.move(to: SCNVector3(x: lipDown.position.x, y: lipDown.position.y - 0.05, z: lipDown.position.z), duration: smileDuration)
        let smileLowerLipRight = SCNAction.move(to: SCNVector3(x: lipDownR.position.x, y: lipDownR.position.y - 0.05, z: lipDownR.position.z), duration: smileDuration)
        
        let smileSideLipLeft = SCNAction.move(to: SCNVector3(x: sideLipL.position.x - 0.04, y: sideLipL.position.y, z: sideLipL.position.z), duration: smileDuration)
        let smileSideLipRight = SCNAction.move(to: SCNVector3(x: sideLipR.position.x + 0.04, y: sideLipR.position.y, z: sideLipR.position.z), duration: smileDuration)
        
        lipUpL.runAction(smileUpperLipLeft)
        lipUp.runAction(smileUpperLipCenter)
        lipUpR.runAction(smileUpperLipRight)
        
        lipDownL.runAction(smileLowerLipLeft)
        lipDown.runAction(smileLowerLipCenter)
        lipDownR.runAction(smileLowerLipRight)
        
        sideLipL.runAction(smileSideLipLeft)
        sideLipR.runAction(smileSideLipRight)
    }
    
    // Function to return lips to their original positions
    func resetSmileAnimation(duration: TimeInterval) {
        
        guard let lipUpL, let lipUpLOrigin, let lipUp, let lipUpOrigin, let lipUpR, let lipUpROrigin,
              let lipDownL, let lipDownLOrigin, let lipDown, let lipDownOrigin, let lipDownR, let lipDownROrigin,
              let sideLipL, let sideLipLOrigin, let sideLipR, let sideLipROrigin
        else { return }
        
        let smileDuration = duration
        
        let returnUpperLipLeft = reset(position: lipUpLOrigin, duration: smileDuration)
        let returnUpperLipCenter = reset(position: lipUpOrigin, duration: smileDuration)
        let returnUpperLipRight = reset(position: lipUpROrigin, duration: smileDuration)
        
        let returnLowerLipLeft = reset(position: lipDownLOrigin, duration: smileDuration)
        let returnLowerLipCenter = reset(position: lipDownOrigin, duration: smileDuration)
        let returnLowerLipRight = reset(position: lipDownROrigin, duration: smileDuration)
        
        let returnSideLipLeft = reset(position: sideLipLOrigin, duration: smileDuration)
        let returnSideLipRight = reset(position: sideLipROrigin, duration: smileDuration)
        
        lipUpL.runAction(returnUpperLipLeft)
        lipUp.runAction(returnUpperLipCenter)
        lipUpR.runAction(returnUpperLipRight)
        
        lipDownL.runAction(returnLowerLipLeft)
        lipDown.runAction(returnLowerLipCenter)
        lipDownR.runAction(returnLowerLipRight)
        
        sideLipL.runAction(returnSideLipLeft)
        sideLipR.runAction(returnSideLipRight)
    }

    private func startSlightlySmileAnimation() {
        createSlightlySmileAnimation(duration: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetSmileAnimation(duration: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.createSlightlySmileAnimation(duration: 1.0)
            }
        }
    }
    
    private func stopSlightlySmileAnimation() {
        resetSmileAnimation(duration: 1.0)
    }

    // MARK: - Idle state trigger functions

    private func startIdleStateAnimation() {
        guard currentState == .none else { return }
        startBlinkEyes(duration: 0.2)
        startHeadRotateAnimation()
        startSlightlySmileAnimation()
        currentState = .idle
    }
    
    private func stopIdleStateAnimation() {
        stopBlinking()
        resetBlinkRandomizeTimer()
        stopHeadRotateAnimation()
        stopSlightlySmileAnimation()
        currentState = .none
    }

    // MARK: - Actions
    
    func animateLipSync(characterNode: SCNNode, visemes: [String], durations: [Double]) {
        // Iterate through each viseme
        for (index, viseme) in visemes.enumerated() {
            let duration = durations[index]
            let halfDuration = duration / 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration * Double(index))) { [weak self] in
                guard let self = self else { return }
                
                print("Animating viseme: \(viseme) for duration: \(duration)")

                // Animate based on the current viseme
                animateViseme(viseme: viseme, halfDuration: halfDuration)
                
                // Reset the mouth shape after the half duration has passed
                DispatchQueue.main.asyncAfter(deadline: .now() + halfDuration) { [weak self] in
                    guard let self = self else { return }
                    
                    print("Resetting mouth shape and closing jaw for viseme: \(viseme)")
                    
                    // Reset mouth shape and close jaw
                    self.resetMouthShape(duration: halfDuration)
                    self.animateJawClose(duration: halfDuration)
                }
            }
        }
        
        // Reset the `currentState` to `.none` after all animations are complete
        DispatchQueue.main.asyncAfter(deadline: .now() + durations.reduce(0, +)) { [weak self] in
            guard let self = self else { return }
            print("All animations complete, setting state to .none")
            self.currentState = .none
        }
    }

    private func animateViseme(viseme: String, halfDuration: Double) {
        switch viseme {
        case "A", "E", "AA": // Wide mouth
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

    
    func animateTalking() {
        guard let characterNode = modelRootNode, currentState == .none else { return }
        currentState = .talking
        
        // A broader list of visemes for testing
        animateLipSync(
            characterNode: characterNode,
            visemes: ["A", "E", "O", "M", "K", "T", "P", "U", "A", "E", "O", "M", "K", "T", "P", "U"],
            durations: Array(repeating: 0.3, count: 16)
        )
    }
}

// MARK: - Helpers

extension ModelTestViewController {
    
    // Return nodes to original positions
    func reset(position: SCNVector3, duration: TimeInterval = 0.5) -> SCNAction {
        let moveBackAction = SCNAction.move(to: position, duration: duration)
        moveBackAction.timingMode = .easeInEaseOut
        return moveBackAction
    }
    
    func lerp(from: SCNVector3, to: SCNVector3, t: Float) -> SCNVector3 {
        return SCNVector3(
            x: from.x + (to.x - from.x) * t,
            y: from.y + (to.y - from.y) * t,
            z: from.z + (to.z - from.z) * t
        )
    }
    
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
