//
//  Floor.swift
//  Colour_Platformer
//
//  Created by United Kingdom Local Admin on 14/02/2019.
//  Copyright © 2019 United Kingdom Local Admin. All rights reserved.
//

import Foundation
import SpriteKit

class Floor: SKNode {
    
    override init() {
        super.init()

        //self.position = CGPoint(x:0, y: -UIScreen.main.bounds.width / 2)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width * 2, height: 1))
        
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
