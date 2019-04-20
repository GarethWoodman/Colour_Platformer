//
//  Player.swift
//  
//
//  Created by United Kingdom Local Admin on 25/02/2019.
//

import Foundation
import SpriteKit
import GameplayKit

class Player {
    
    var node: SKSpriteNode
    var gravity = CGFloat(0.4)
    var velocity = CGFloat(1)
    var isDucking = false
    var defaultSize:CGSize
    
    init(node: SKSpriteNode) {
        self.node = node
        self.node.color = .blue
        defaultSize = node.size
    }
    
    func jump() {
        self.velocity = -15
    }
    
    func airBorne() {
        self.node.position.y -= self.velocity
        self.velocity += self.gravity
    }
    
    func duck() {
        let duck = SKAction.resize(toHeight: 50, duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.8)
        let stand = SKAction.resize(toHeight: defaultSize.height, duration: 0.1)
        let standing = SKAction.run { self.isDucking = false }
        let duckAction = SKAction.sequence([duck, wait, stand, standing])
        self.node.run(duckAction, withKey: "duck")
    }
    
    func hitObject() {
        //print("Hit by Square")

        let vanish = SKAction.run({
            self.node.alpha = 0
        })
        let appear = SKAction.run({
            self.node.alpha = 1
        })
        let waitForFlash = SKAction.wait(forDuration: 0.1)
        let flashing = SKAction.sequence([vanish, waitForFlash, appear,
                                          waitForFlash, vanish, waitForFlash, appear])
        node.run(flashing, withKey: "flashing")
    }
    
    func changeColour(colour: UIColor) {
        self.node.color = colour
    }
}
