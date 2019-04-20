//
//  GameScene.swift
//  Colour_Platformer
//
//  Created by United Kingdom Local Admin on 13/02/2019.
//  Copyright © 2019 United Kingdom Local Admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Pushing to GitHub
    
    var player : Player!
    var baseFloor = SKSpriteNode()
    var colorArray: [UIColor] = []
    var background = SKSpriteNode()
    var backgroundTextures:[SKTexture] = []
    
    var bushesOne = SKSpriteNode()
    var bushesTwo = SKSpriteNode()
    
    var frontTreesOne = SKSpriteNode()
    var frontTreesTwo = SKSpriteNode()
    
    var backTreesOne = SKSpriteNode()
    var backTreesTwo = SKSpriteNode()
    
    var backgroundObjects: [[Any]] = []
    
    var durBetwnObj: Double = 2
    var objSpd:Double = 3
    
    var parentObject = SKSpriteNode()
    var objects: [SKSpriteNode] = []
    var checkObjects: [SKSpriteNode] = []
    
    var spawnTop = SKSpriteNode()
    var spawnBottom = SKSpriteNode()
    var spawnFuncOn = false
    
    var blueButton = SKSpriteNode()
    var redButton = SKSpriteNode()
    var greenButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    
    var livesLabelCounter = SKLabelNode()
    var lives = 3
    
    var timeCounter = SKLabelNode()
    var timeSecs = 0
    
    var topCounter = SKLabelNode()
    var topSecs = 0
    
    var restartButtonTrue = false
    var gameOverCheck = false
    var canJump = false
    
    var counter = 0
    var touched = 0
    
    var objectCounter = 0
    
    var isDipping = false
    
    var backgroundSpeed = CGFloat(5)
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        if self.player.isDucking == false {
            self.player.isDucking = true
            self.player.duck()
        } else {
            stayDucking()
        }
        
        if canJump == false {
            //self.player.node.removeAllActions()
            removeAllActionsExceptHit()
            self.player.velocity += 15
            self.player.node.run(SKAction.resize(toWidth: self.player.defaultSize.width/2, duration: 0.1), withKey: "dips")
            isDipping = true
        }
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        if canJump && lives != 0 {
            //player.node.removeAllActions()
            removeAllActionsExceptHit()
            self.player.isDucking = false
            
            self.player.node.run(SKAction.resize(toWidth: self.player.defaultSize.width, height: self.player.defaultSize.height, duration: 0.1), withKey: "jump")
            canJump = false
            player.jump()
        }
    }
    
    //Initialize objects before scene is presented
    override func didMove(to view: SKView) {
        
        let swipeDown:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        let swipeUp:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        background = self.childNode(withName: "background") as! SKSpriteNode
        //background.zPosition = -10
       // for i in 0...39 {
            //backgroundTextures.append(SKTexture(imageNamed: "frame_\(i)_delay-0.04s"))
        //}
        //background.run(SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.04)))
        
        parentObject = self.childNode(withName: "parentObject") as! SKSpriteNode

        for child in parentObject.children as! [SKSpriteNode]{
            if child.name == "bottomObject" || child.name == "topObject" || child.name == "wallObject" {
                child.zPosition = -1
                objects.append(child)
            }
        }
        
        parentObject.removeChildren(in: objects)
        
        spawnTop = self.childNode(withName: "spawnTop") as! SKSpriteNode
        spawnBottom = self.childNode(withName: "spawnBottom") as! SKSpriteNode
        
        colorArray = [.red, .purple, .blue]
        player = Player(node: childNode(withName: "player") as! SKSpriteNode)
        //player.node.texture = SKTexture(imageNamed: "player_head")
        
        bushesOne = self.childNode(withName: "bushesOne") as! SKSpriteNode
        bushesTwo = self.childNode(withName: "bushesTwo") as! SKSpriteNode
        bushesOne.zPosition = -10
        bushesTwo.zPosition = -10
        backgroundObjects.append([bushesOne, bushesTwo, CGFloat(1.25), bushesOne.position.y])
        
        frontTreesOne = self.childNode(withName: "frontTreesOne") as! SKSpriteNode
        frontTreesTwo = self.childNode(withName: "frontTreesTwo") as! SKSpriteNode
        frontTreesOne.zPosition = -20
        frontTreesTwo.zPosition = -20
        backgroundObjects.append([frontTreesOne, frontTreesTwo, CGFloat(1), frontTreesOne.position.y])
        
        backTreesOne = self.childNode(withName: "backTreesOne") as! SKSpriteNode
        backTreesTwo = self.childNode(withName: "backTreesTwo") as! SKSpriteNode
        backTreesOne.zPosition = -30
        backTreesTwo.zPosition = -30
        backgroundObjects.append([backTreesOne, backTreesTwo, CGFloat(0.75), backTreesOne.position.y])
        
        baseFloor = self.childNode(withName: "baseFloor") as! SKSpriteNode
        baseFloor.physicsBody?.restitution = 0.0
        
        blueButton = self.childNode(withName: "blueButton") as! SKSpriteNode
        redButton = self.childNode(withName: "redButton") as! SKSpriteNode
        greenButton = self.childNode(withName: "greenButton") as! SKSpriteNode
        restartButton = self.childNode(withName: "restartButton") as! SKSpriteNode
        self.restartButton.alpha = 0
        
        topCounter = restartButton.childNode(withName: "topCounter") as! SKLabelNode
        livesLabelCounter = self.childNode(withName: "livesLabelCounter") as! SKLabelNode
        timeCounter = self.childNode(withName: "timeCounter") as! SKLabelNode
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if restartButton.contains(pos) && restartButtonTrue {
            canJump = false
            
            self.touched = 0
            self.lives = 30
            timeSecs = 0
            durBetwnObj = 2
            objSpd = 3
            
            self.restartButton.alpha =  0
            self.restartButtonTrue = false
            
            
            for object in objects {
                object.position.y = 10000
                object.removeFromParent()
            }
            
            self.removeAction(forKey: "spawnObjects")
            self.checkObjects.removeAll()
            
            self.player.node.isPaused = false
            self.player.isDucking = false
            self.player.node.size = self.player.defaultSize
            
            self.backgroundSpeed = 5 
            
            self.spawnObjects()
        }
        
        if redButton.contains(pos) && restartButtonTrue == false {
            player.changeColour(colour: .red)
        }
        
        if blueButton.contains(pos) && restartButtonTrue == false {
            player.changeColour(colour: .blue)
        }
        
        if greenButton.contains(pos) && restartButtonTrue == false {
            player.changeColour(colour: .purple)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        counter += 1
        
        print("Objects Speed: \(objSpd)")
        print("Next Object in: \(durBetwnObj)")
        print(self.player.isDucking)
        
        if self.lives > 0 && counter > 60 {
            counter = 0
            self.timeSecs += 1
        }
        
        livesLabelCounter.text = String(lives)
        timeCounter.text = String(timeSecs)
        
        collisionDetection()
        moveObj()
        
        if spawnFuncOn == false {
            spawnObjects()
        }
        
    }
    
    func spawnObject() {
        var rObj = Int.random(in: 0...objects.count-1)
        var rCol = Int.random(in : 0...colorArray.count-1)
        
        var object = objects[rObj]
        
        while checkObjects.contains(object) {
            rObj = Int.random(in: 0...objects.count-1)
            rCol = Int.random(in: 0...colorArray.count-1)
            object = objects[rObj]
        }
        
        //Default settings if object is not bottom or top
        object.color = colorArray[rCol]
        object.position = spawnBottom.position
        
        if object.name == "topObject" {
            object.color = .white
            object.position = spawnTop.position
        }
        if object.name == "bottomObject" {
            object.color = .white
            object.position = spawnBottom.position
        }
        
        self.addChild(object)
        checkObjects.append(object)
        
        object.run(SKAction.sequence([
            SKAction.moveTo(x: -object.size.width, duration: self.objSpd),
            SKAction.run{object.removeFromParent()},
            SKAction.run{self.checkObjects.removeFirst()}]))
    }
    
    func spawnObjects() {
        run(SKAction.sequence([
            SKAction.run{self.spawnFuncOn = true},
            SKAction.run(spawnObject),
            SKAction.wait(forDuration: self.durBetwnObj),
            SKAction.run(speedUpObjects),
            SKAction.run{self.spawnFuncOn = false}]),
            withKey: "spawnObjects")
    }

    func objectHitsPlayer(_ object: SKSpriteNode) {
        if object.intersects(self.player.node) && lives > 0 {
            if player.node.color != object.color {
                touched += 1
                if touched > 2 && gameOverCheck == false {
                    //takes 62 frames before player can be "hit" again or 1 second roughly
                    touched -= 60
                    lives -= 1
                    run(SKAction.sequence([
                        SKAction.run(player.hitObject),
                        SKAction.wait(forDuration: 1.0),
                        SKAction.run{ self.touched = 0}]))
                }
            }
        }
    }
    
    func collisionDetection() {
        for object in objects {
            objectHitsPlayer(object)
        }
        
        if lives == 0 {
            gameOver()
        }
        
        if player.node.intersects(baseFloor) {
            player.velocity = 0
            player.node.position.y = baseFloor.position.y+0.1
            canJump = true
            //player.node.removeAllActions()
            removeAllActionsExceptHit()
            checkDipping()
        } else {
            if canJump == false {
                player.airBorne()
                if player.node.position.y < baseFloor.position.y+10{
                    player.node.position.y = baseFloor.position.y
                }
            }
        }
    }
    
    func speedUpObjects() {
        objectCounter += 1
        if objectCounter == 5 {
            objectCounter = 0
            if durBetwnObj > 1 {
                durBetwnObj -= 0.1
            }
            if objSpd > 0.7 {
               backgroundSpeed += 0.1
               objSpd -= 0.1
            }
        }
    }
    
    func checkDipping() {
        if isDipping {
            self.isDipping = false
            let squash = SKAction.resize(toWidth: self.player.defaultSize.width, height: 50, duration: 0.05)
            let wait = SKAction.wait(forDuration: 0.8)
            let stand = SKAction.resize(toHeight: self.player.defaultSize.height, duration: 0.1)
            let duckingOff = SKAction.run{ self.player.isDucking = false }
            self.player.node.run(SKAction.sequence([squash, wait, stand, duckingOff]), withKey: "checkDipping")
        }
    }
    
    func stayDucking() {
        //self.player.node.removeAllActions()
        removeAllActionsExceptHit()
        let stayDuck = SKAction.resize(toHeight: 50, duration: 0)
        let wait = SKAction.wait(forDuration: 0.8)
        let stand = SKAction.resize(toHeight: self.player.defaultSize.height, duration: 0.1)
        let notDucking = SKAction.run{ self.player.isDucking = false }
        self.player.node.run(SKAction.sequence([stayDuck, wait, stand, notDucking]), withKey: "stayDucking")
    }
    
    func removeAllActionsExceptHit() {
        self.player.node.removeAction(forKey: "checkDipping")
        self.player.node.removeAction(forKey: "stayDucking")
        self.player.node.removeAction(forKey: "dips")
        self.player.node.removeAction(forKey: "jump")
        self.player.node.removeAction(forKey: "duck")
    }
    
    func gameOver() {
        spawnFuncOn = true
        
        if timeSecs > topSecs {
            topSecs = timeSecs
        }
            
        self.restartButton.alpha =  1
        self.restartButtonTrue = true
            
        self.topCounter.text = String(topSecs)
            
        player.velocity = 0
        self.player.node.isPaused = true
        self.player.node.removeAllActions()
        self.backgroundSpeed = 0
        for object in checkObjects {
            object.removeAllActions()
        }
    }
    
    func moveObj(){
        for object in backgroundObjects {
            let objectOne = object[0] as! SKSpriteNode
            let objectTwo = object[1] as! SKSpriteNode
            let objectSpeed = object[2] as! CGFloat
            let objectPosY = object[3] as! CGFloat
            
            let objects = [objectOne, objectTwo]
            let objectWidth = objectOne.size.width
            
            for object in objects {
                object.position.x -= (objectSpeed * backgroundSpeed)
                if object.position.x < -objectWidth {
                    object.removeFromParent()
                    object.position = CGPoint(x: objectWidth, y: objectPosY)
                    self.addChild(object)
                }
            }
            
        }
        
    }

    
}
