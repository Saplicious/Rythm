//
//  JacksDemo.swift
//  Rhythm
//
//  Created by Jack Jiang on 8/31/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class JacksDemo: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let char = SKSpriteNode(imageNamed: "board")
    let left = SKSpriteNode(imageNamed: "left")
    let right = SKSpriteNode(imageNamed: "right")
    var tiles:[SKSpriteNode] = [SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile"),SKSpriteNode(imageNamed:"tile")]
    var onScreen:[Int] = [0,0,0,0,0,0,0,0,0,0,0]
    
    var xPos = 0.0
    var current = 0
    var previous = 0
    
    
    override func sceneDidLoad() {
        print("Scene LOadddddded")
        self.lastUpdateTime = 0
        self.backgroundColor = SKColor(red: 36/255, green: 46/255, blue: 48/255, alpha: 1.0)
        
        load()
        
        
    }
    func load() {
        
        char.size = CGSize(width: 150, height: 23)
        char.zPosition = 2
        char.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        char.position = CGPoint(x:0, y:-500)
        self.addChild(char)
        
        left.zPosition = 1
        left.size = CGSize(width: self.size.width/2, height: self.size.height)
        left.anchorPoint = CGPoint(x: 1, y: 0.5)
        left.position = CGPoint(x:0, y:0)
        self.addChild(left)
        right.zPosition = 1
        right.size = CGSize(width: self.size.width/2, height: self.size.height)
        right.anchorPoint = CGPoint(x: 0, y: 0.5)
        right.position = CGPoint(x:0, y:0)
        self.addChild(right)
        
        tileGenerator(pos: 0)
        
    }
    func tileGenerator(pos: Int) {
        var randomPosition = 0
        if current != 0 {
            previous = current - 1
            randomPosition = (Int(arc4random_uniform(3)) - 1) * Int(tiles[current].size.width + tiles[previous].position.x)
        }
        
        
        let realCurrent = current
        onScreen[current] = 1
        
        tiles[current].zPosition = 2
        tiles[current].size = CGSize(width: 210, height: 210)
        tiles[current].anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        tiles[current].position = CGPoint(x:randomPosition, y:800)
        print("random Position: " + String(randomPosition))
        print("random Position: ------------------")
        self.addChild(tiles[current])
        onScreen[current] = 1
        
        tiles[current].run(SKAction.sequence([SKAction.moveBy(x: 0, y: -1600, duration: 2.0), SKAction.removeFromParent(), SKAction.run {
            self.onScreen[realCurrent] = 0
            }]))
        
        if current == 10 {
            current = 0
            previous = 10
        }
        else{
            current += 1
        }
        
        run(SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.run {
            self.tileGenerator(pos: 0)
            }]))
        
    }
    
    func goLeft()  {
        for i in 0..<11{
            if onScreen[i] == 1{
                tiles[i].run(SKAction.moveBy(x: 200, y: 0, duration: 0.05))
            }
        }
    }
    
    func goRight()  {
        for i in 0..<11{
            if onScreen[i] == 1{
                tiles[i].run(SKAction.moveBy(x: -200, y: 0, duration: 0.05))
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            
            if left.contains(t.location(in: self)) {
                
                left.alpha = 0.2
                goLeft()
                
            }
            if right.contains(t.location(in: self)) {
                
                right.alpha = 0.2
                goRight()
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if left.contains(t.location(in: self)) {
                
                left.alpha = 1.0
                
            }
            if right.contains(t.location(in: self)) {
                
                right.alpha = 1.0
                
            }
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
