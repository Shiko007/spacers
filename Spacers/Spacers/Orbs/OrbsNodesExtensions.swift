//
//  OrbsNodesExtensions.swift
//  Spacers
//
//  Created by Sherif Yasser on 12.09.24.
//

import SpriteKit

extension OrbNode {
    func runRotationAction(duration: TimeInterval) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: duration)
        let repeatRotationAction = SKAction.repeatForever(rotateAction)
        run(repeatRotationAction)
    }
}

