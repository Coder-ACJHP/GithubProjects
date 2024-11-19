//
//  ModelTestViewController+Extensions.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 14.11.2024.
//

import Foundation
import SceneKit
import NaturalLanguage

extension ModelTestViewController {
    
    // MARK: - Talking Animations
    
    func animateJawOpen(jaw: SCNNode, power: Float = -0.3, duration: TimeInterval) {
        let openAction = SCNAction.move(to: SCNVector3(x: 0, y: power, z: 0.0), duration: duration)
        jaw.runAction(openAction)
    }

    func animateJawClose(duration: TimeInterval) {
        guard let jaw = character.jaw else { return }
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
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let jaw = character.jaw
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
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let sideLipL = character.sideLipL, let sideLipR = character.sideLipR,
              let jaw = character.jaw
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
    
    func resetMouthShape(duration: TimeInterval = 0.5) {
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipUpLOrigin = character.lipUpLOrigin, let lipUpOrigin = character.lipUpOrigin, let lipUpROrigin = character.lipUpROrigin,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let lipDownLOrigin = character.lipDownLOrigin, let lipDownOrigin = character.lipDownOrigin, let lipDownROrigin = character.lipDownROrigin,
              let sideLipL = character.sideLipL, let sideLipR = character.sideLipR,
              let sideLipLOrigin = character.sideLipLOrigin, let sideLipROrigin = character.sideLipROrigin
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
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR
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

    func startBlinkEyes(duration: TimeInterval) {
        resetBlinkRandomizeTimer()
        createBlinkRandomizeTimer(blinkDuration: duration)
    }
    
    // Function to create a random blink sequence with 1 or 2 blinks
    func createRandomBlinkSequence(count: Int, duration: TimeInterval) -> (SCNAction, SCNAction, SCNAction, SCNAction) {
        guard let eyeLidUpL = character.eyeLidUpL, let eyeLidUpLOrigin = character.eyeLidUpLOrigin,
              let eyeLidUpR = character.eyeLidUpR, let eyeLidUpROrigin = character.eyeLidUpROrigin,
              let eyeLidDownL = character.eyeLidDownL, let eyeLidDownLOrigin = character.eyeLidDownLOrigin,
                let eyeLidDownR = character.eyeLidDownR, let eyeLidDownROrigin = character.eyeLidDownROrigin else {
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
        guard let eyeLidUpL = character.eyeLidUpL,
              let eyeLidUpR = character.eyeLidUpR,
              let eyeLidDownL = character.eyeLidDownL,
              let eyeLidDownR = character.eyeLidDownR
        else {
            return print("Required eyelid nodes not found")
        }
        let (upperLidActionL, upperLidActionR, lowerLidActionL, lowerLidActionR) = createRandomBlinkSequence(count: count, duration: duration)
        // Repeat forever with new randomized blink sequences in each cycle
        eyeLidUpL.runAction(SCNAction.repeatForever(upperLidActionL))
        eyeLidUpR.runAction(SCNAction.repeatForever(upperLidActionR))
        eyeLidDownL.runAction(SCNAction.repeatForever(lowerLidActionL))
        eyeLidDownR.runAction(SCNAction.repeatForever(lowerLidActionR))
    }
    
    func stopBlinking() {
        guard let eyeLidUpL = character.eyeLidUpL,
              let eyeLidUpR = character.eyeLidUpR,
              let eyeLidDownL = character.eyeLidDownL,
              let eyeLidDownR = character.eyeLidDownR
        else {
            return print("Required eyelid nodes not found")
        }
        eyeLidUpL.removeAllActions()
        eyeLidUpR.removeAllActions()
        eyeLidDownL.removeAllActions()
        eyeLidDownR.removeAllActions()
    }

    
    func createBlinkRandomizeTimer(blinkDuration duration: TimeInterval) {
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
    
    func resetBlinkRandomizeTimer() {
        if idleStateTimer != nil {
            idleStateTimer?.invalidate()
            idleStateTimer = nil
        }
    }
    
    // MARK: - Head Rotate Animation
    
    func startHeadRotateAnimation() {
        guard let head = character.head,
              let eyeLeft = character.eyeLeft, let eyeLeftOrigin = character.eyeLeftOrigin,
              let eyeRight = character.eyeRight, let eyeRightOrigin = character.eyeRightOrigin,
              let eyeBrowLR = character.eyeBrowLR, let eyeBrowLROrigin = character.eyeBrowLROrigin,
              let eyeBrowRL = character.eyeBrowRL, let eyeBrowRLOrigin = character.eyeBrowRLOrigin
        else {
            return print("Required eyebrow nodes not found")
        }
        // Store the original orientation of the head and eye positions
        let headOriginAngles = head.eulerAngles
        
        // Function to create random head movement with synchronized eye movement
        func createHeadAndEyeMovementSequence() -> SCNAction {
            // Define small rotation angles for slight head movement
            let randomAngleX = Float.random(in: -0.05...0.05)  // Horizontal movement
            let randomAngleY = Float.random(in: -0.05...0.05)  // Vertical movement
            // Create slight rotation action for the head
            let rotateHead = SCNAction.rotateBy(
                x: CGFloat(randomAngleX),
                y: CGFloat(randomAngleY),
                z: 0,
                duration: 1.0
            )
            // Return head and eyes back to original positions
            let returnHeadToOrigin = SCNAction.rotateTo(
                x: CGFloat(headOriginAngles.x),
                y: CGFloat(headOriginAngles.y),
                z: CGFloat(headOriginAngles.z),
                duration: 1.0
            )
            returnHeadToOrigin.timingMode = .easeOut

            // Define small random movements for the eyes
            let randomEyeOffsetX = Float.random(in: -0.03...0.03)
            let randomEyeOffsetY = Float.random(in: -0.03...0.03)
            
            // Move eyes slightly in sync with the head rotation
            let moveEyes = SCNAction.run { _ in
                eyeLeft.position = SCNVector3(
                    eyeLeftOrigin.x + randomEyeOffsetX,
                    eyeLeftOrigin.y + randomEyeOffsetY,
                    eyeLeftOrigin.z
                )
                eyeRight.position = SCNVector3(
                    eyeRightOrigin.x + randomEyeOffsetX,
                    eyeRightOrigin.y + randomEyeOffsetY,
                    eyeRightOrigin.z
                )
            }
            moveEyes.timingMode = .easeIn
            
            let resetEyesToOrigin = SCNAction.run { [weak self] _ in
                guard let self else { return }
                eyeLeft.runAction(reset(position: eyeLeftOrigin, duration: 0.5))
                eyeRight.runAction(reset(position: eyeRightOrigin, duration: 0.5))
            }
            resetEyesToOrigin.timingMode = .easeOut
            
            // Create eyebrow movement action (random up and down)
            let randomBrowOffsetY = Float.random(in: 0.0...0.05)  // Vertical movement for eyebrows
            let moveEyebrows = SCNAction.run { _ in
                eyeBrowLR.position = SCNVector3(
                    eyeBrowLROrigin.x,
                    eyeBrowLROrigin.y + randomBrowOffsetY,
                    eyeBrowLR.position.z
                )
                eyeBrowRL.position = SCNVector3(
                    eyeBrowRLOrigin.x,
                    eyeBrowRLOrigin.y + randomBrowOffsetY,
                    eyeBrowRL.position.z
                )
            }
            moveEyebrows.timingMode = .easeIn
            
            let resetBrowsToOrigin = SCNAction.run { [weak self] _ in
                guard let self else { return }
                eyeBrowLR.runAction(reset(position: eyeBrowLROrigin, duration: 0.5))
                eyeBrowRL.runAction(reset(position: eyeBrowRLOrigin, duration: 0.5))
            }
            resetBrowsToOrigin.timingMode = .easeOut
            
            // Define delays to avoid constant movement and create a natural look
            let slightDelay = SCNAction.wait(duration: 1.5)
            // Random delay for brow movement
            let browMovementDelay = SCNAction.wait(duration: TimeInterval(Float.random(in: 4...7)))
            // Sequence: move head, eyes, and brows -> delay -> return to origin -> delay
            return SCNAction.sequence([
                // Move head, eyes, and eyebrows
                SCNAction.group([rotateHead, moveEyes, moveEyebrows]),
                slightDelay,
                // Reset head, eyes, and eyebrows
                SCNAction.group([returnHeadToOrigin, resetEyesToOrigin, resetBrowsToOrigin]),
                slightDelay,
                browMovementDelay // Random delay before next brow movement
            ])
        }
        
        // Recursive function to loop idle head and eye animation
        func runIdleHeadAndEyeAnimation() {
            let headAndEyeMovementSequence = createHeadAndEyeMovementSequence()
            // Run sequence and repeat for continuous idle animation
            head.runAction(headAndEyeMovementSequence) {
                runIdleHeadAndEyeAnimation() // Recursively call for ongoing idle animation
            }
        }
        
        // Start the first idle head and eye animation cycle
        runIdleHeadAndEyeAnimation()
    }

    func stopHeadRotateAnimation() {
        guard let head = character.head, let headOrigin = character.headOrigin,
              let eyeLeft = character.eyeLeft, let eyeLeftOrigin = character.eyeLeftOrigin,
              let eyeRight = character.eyeRight, let eyeRightOrigin = character.eyeRightOrigin,
              let eyeBrowLR = character.eyeBrowLR, let eyeBrowLROrigin = character.eyeBrowLROrigin,
              let eyeBrowRL = character.eyeBrowRL, let eyeBrowRLOrigin = character.eyeBrowRLOrigin
        else {
            return print("Required eyebrow nodes not found")
        }
        head.runAction(reset(position: headOrigin, duration: 0.5))
        // Reset eye positions to their origins when stopping the animation
        eyeLeft.runAction(reset(position: eyeLeftOrigin, duration: 0.5))
        eyeRight.runAction(reset(position: eyeRightOrigin, duration: 0.5))
        eyeBrowLR.runAction(reset(position: eyeBrowLROrigin, duration: 0.5))
        eyeBrowRL.runAction(reset(position: eyeBrowRLOrigin, duration: 0.5))
    }

    // MARK: - Smile Animation
    
    // Slight smile animation
    private func createSlightlySmileAnimation(duration: TimeInterval) {
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let sideLipL = character.sideLipL, let sideLipR = character.sideLipR
        else {
            return print("Required lip nodes not found")
        }
        
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
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let sideLipL = character.sideLipL, let sideLipR = character.sideLipR
        else {
            return print("Required lip nodes not found")
        }
                
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
        guard let lipUpL = character.lipUpL, let lipUp = character.lipUp, let lipUpR = character.lipUpR,
              let lipUpLOrigin = character.lipUpLOrigin, let lipUpOrigin = character.lipUpOrigin, let lipUpROrigin = character.lipUpROrigin,
              let lipDownL = character.lipDownL, let lipDown = character.lipDown, let lipDownR = character.lipDownR,
              let lipDownLOrigin = character.lipDownLOrigin, let lipDownOrigin = character.lipDownOrigin, let lipDownROrigin = character.lipDownROrigin,
              let sideLipL = character.sideLipL, let sideLipR = character.sideLipR,
              let sideLipLOrigin = character.sideLipLOrigin, let sideLipROrigin = character.sideLipROrigin
        else {
            return print("Required lip nodes not found")
        }
        
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

    func startSlightlySmileAnimation() {
        createSlightlySmileAnimation(duration: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetSmileAnimation(duration: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.createSlightlySmileAnimation(duration: 1.0)
            }
        }
    }
    
    func stopSlightlySmileAnimation() {
        resetSmileAnimation(duration: 1.0)
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
    
    func detectLanguageOf(text: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        guard let language = recognizer.dominantLanguage else { return nil}
        return language
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
