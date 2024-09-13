//
//  EnemyNode.swift
//  Spacers
//
//  Created by Sherif Yasser on 13.09.24.
//

import SpriteKit

class EnemyNode: SKShapeNode {
    
    // Custom initializer to create an enemy shape
    convenience init(size: CGSize, color: UIColor) {
        self.init()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -size.width / 2, y: -size.height / 2))
        path.addLine(to: CGPoint(x: size.width / 2, y: -size.height / 2))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2))
        path.closeSubpath()
        
        self.path = path
        self.fillColor = color
        self.strokeColor = color
        self.zPosition = 1
    }
}
