//
//  Character.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 14.11.2024.
//

import Foundation
import SceneKit

struct Character {
    
    enum State {
        case talking, idle, none
    }

    // Store talking text
    var talkingText: String = ""
    // States
    var state: State = .none
    // 1 - Jaw
    private(set) var jaw: SCNNode?
    var jawOrigin: SCNVector3?
    // 2 - Lips
    private(set) var lipUpL: SCNNode?
    var lipUpLOrigin: SCNVector3?
    private(set) var lipUp: SCNNode?
    var lipUpOrigin: SCNVector3?
    private(set) var lipUpR: SCNNode?
    var lipUpROrigin: SCNVector3?
    private(set) var lipDownL: SCNNode?
    var lipDownLOrigin: SCNVector3?
    private(set) var lipDown: SCNNode?
    var lipDownOrigin: SCNVector3?
    var lipDownROrigin: SCNVector3?
    private(set) var lipDownR: SCNNode?
    private(set) var sideLipL: SCNNode?
    var sideLipLOrigin: SCNVector3?
    private(set) var sideLipR: SCNNode?
    var sideLipROrigin: SCNVector3?
    // 3 - Eyelid
    private(set) var eyeLidUpR: SCNNode?
    var eyeLidUpROrigin: SCNVector3?
    private(set) var eyeLidUpL: SCNNode?
    var eyeLidUpLOrigin: SCNVector3?
    private(set) var eyeLidDownL: SCNNode?
    var eyeLidDownLOrigin: SCNVector3?
    private(set) var eyeLidDownR: SCNNode?
    var eyeLidDownROrigin: SCNVector3?
    // 4 - Head
    private(set) var head: SCNNode?
    var headOrigin: SCNVector3?
    // 5 - Eyes
    private(set) var eyeLeft: SCNNode?
    var eyeLeftOrigin: SCNVector3?
    private(set) var eyeRight: SCNNode?
    var eyeRightOrigin: SCNVector3?
    // 6 - Eyebrows
    private(set) var eyeBrowLR: SCNNode?
    var eyeBrowLROrigin: SCNVector3?
    private(set) var eyeBrowRL: SCNNode?
    var eyeBrowRLOrigin: SCNVector3?
    
    init(from rootNode: SCNNode?) {
        loadReuiredNodes(from: rootNode)
    }
    
    private mutating func loadReuiredNodes(from rootNode: SCNNode?) {
        guard let characterNode = rootNode else { return  }
        // Face Parts
        // 1 - Jaw
        jaw = characterNode.childNode(withName: "jaw", recursively: true)
        jawOrigin = jaw?.position
        // 2 - Eyes
        eyeLeft = characterNode.childNode(withName: "Eye_L", recursively: true)
        eyeLeftOrigin = eyeLeft?.position
        eyeRight = characterNode.childNode(withName: "Eye_R", recursively: true)
        eyeRightOrigin = eyeRight?.position
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
        // 6 - Eyebrows
        eyeBrowLR = characterNode.childNode(withName: "BrowHigh_R", recursively: true)
        eyeBrowLROrigin = eyeBrowLR?.position
        eyeBrowRL = characterNode.childNode(withName: "BrowHigh_L", recursively: true)
        eyeBrowRLOrigin = eyeBrowRL?.position
    }
}
