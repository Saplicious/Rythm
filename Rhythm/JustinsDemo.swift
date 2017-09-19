//
//  JustinsDemo.swift
//  Rhythm
//
//  Created by Justin Li on 9/18/17.
//  Copyright © 2017 William Wong. All rights reserved.
//



import Foundation

import SpriteKit
import GameplayKit

class JustinsDemo: SKScene {
    
    var player = SKSpriteNode()
    var playerStarted: Bool = false
    
    var tileMaster = SKNode()
    //var shadowMaster = SKNode()
    
    var arrayOfNumbers: [Int] = [-1]
    var currentNumberPosition = 0
    var currentTilePosition = 0
    //position per second
    var currentCatcherPosition = 0
    var catcherSpeed = 0
    var tileSize: CGFloat = 206
    var tileSize2: CGFloat = 258
    
    var scoreNode = SKLabelNode()
    var score = 0
    
    var layer = 1000000
    //speed of blocks and player moving downwards
    
    
    override func sceneDidLoad() {
        load()
        let background = SKSpriteNode(imageNamed: "brown")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 0
        addChild(background)
        self.backgroundColor = .brown
    }
    
    //generate numbers 0,1
    func generate() {
        let rn = Int(arc4random_uniform(4))
        arrayOfNumbers.append(rn)
    }
    //FALL OFF DELAY << SUGGESTION
    
    //once the scene loads
    func load() {
        //add the first tile
        spawnTile()
        catcherSpeed = 1
        
        //generate 50 numbers and tiles
        var count = 0
        for _ in 1...100{
            generate()
            if arrayOfNumbers[count+1] == 0 {
                //tile goes left
                spawnTile()
            }
            else if arrayOfNumbers[count+1] == 1 {
                // tile goes right
                spawnTile()
            }
            else if arrayOfNumbers[count+1] == 2 {
                // tile goes up
                spawnTile()
            }
            else if arrayOfNumbers[count+1] == 3 {
                // tile goes down
                spawnTile()
            }
            count += 1
        }
        
        self.addChild(tileMaster)
        tileMaster.zPosition = 3
        //self.addChild(shadowMaster)
        //shadowMaster.zPosition = 2
        
        //load the scoreNode
        scoreNode.text = String(score)
        scoreNode.color = UIColor.white
        scoreNode.position = CGPoint(x:300 ,y: 600)
        
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 30, height: 37.5)
        player.position = CGPoint(x: 0 ,y: -150)
        
        self.addChild(scoreNode)
        self.addChild(player)
        
        
    }
    
    //move
    func move(location: CGPoint) {
        
        
        
        if (arrayOfNumbers[currentNumberPosition] == 0) {
            
            tileMaster.run(SKAction.moveBy(x: (-tileSize / 2) + 2.5, y: -tileSize2 / 3.4, duration: 0.15))
            //shadowMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            
            
        } else if (arrayOfNumbers[currentNumberPosition] == 1) {
            
            
            tileMaster.run(SKAction.moveBy(x: (tileSize / 2) - 2.5, y: -tileSize2 / 3.4, duration: 0.15))
            //shadowMaster.run(SKAction.moveBy(x: -tileSize, y: -tileSize, duration: 0.15))
            
            
        } else if (arrayOfNumbers[currentNumberPosition] == 2) {
            
            tileMaster.run(SKAction.moveBy(x: -tileSize / 2  + 2.5, y: -tileSize2 / 1.5, duration: 0.15))

            
        }
        else if (arrayOfNumbers[currentNumberPosition] == 3) {
            
            tileMaster.run(SKAction.moveBy(x: tileSize / 2 - 2.5, y: 25, duration: 0.15))
    
        }
    
        if (location.x <= 0) {
            //move left
            //print("moved left")
            if arrayOfNumbers[currentNumberPosition] == 0 {
                success()
            } else {
                lose()
            }
            
        } else {
            //move right
            //print("moved right")
            if arrayOfNumbers[currentNumberPosition] == 1 {
                success()
            } else {
                lose()
            }
            
        }
        generate()
        spawnTile()
        currentNumberPosition += 1
        if currentTilePosition != 99 {
            currentTilePosition += 1
            
        }
        print(currentTilePosition)
        
        print(tileMaster.children.count)
        
        player.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 80, duration: 0.075),SKAction.run {
            self.player.zPosition = CGFloat(self.layer + 208)
            },SKAction.moveBy(x: 0, y: -80, duration: 0.075)]))
        //tileMaster.position = CGPoint(x: tileMaster.position.x ,y: tileMaster.position.y - tileSize)
        
        
    }
    
    //generate tiles
    func spawnTile() {
        

        //very first tile
        if tileMaster.children.count == 0 {
            let startTile = SKSpriteNode(color: UIColor.blue, size: CGSize(width: tileSize, height: tileSize2))
            startTile.position = CGPoint(x: 0 ,y: -200)
            tileMaster.addChild(startTile)
            return
        }
        
        //initialize tile
        
        let tile2 = SKSpriteNode(imageNamed: "block")
        tile2.size = CGSize(width: tileSize, height: tileSize2)
        
        
        //check to see if tile should be spawned to the left or right
        if arrayOfNumbers.last! == 0 {
            //right
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x + (tileSize/2) - 2.5, y:((tileMaster.children.last?.position)!.y + (tileSize2 / 3.4)))

            
        }
        else if arrayOfNumbers.last! == 1 {
            //left
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x - (tileSize / 2) + 2.5, y:((tileMaster.children.last?.position)!.y + (tileSize2 / 3.4)))
        }
        else if arrayOfNumbers.last! == 2 {
            //up
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x + (tileSize / 2) - 2.5, y:((tileMaster.children.last?.position)!.y + (tileSize2/1.5)))
        }
        else if arrayOfNumbers.last! == 3 {
            //down
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x - (tileSize / 2) + 2.5, y:((tileMaster.children.last?.position)!.y - 25))
        }
        
        tile2.zPosition = CGFloat(layer)
        layer = layer - 2
        
        
        tileMaster.addChild(tile2)
        

        if tileMaster.children.count > 200 {
            tileMaster.children.first?.removeFromParent()
        }

    }
    
    //pressed correct side
    func success() {
        //update score
        score += 1
        scoreNode.text = String(score)
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).texture = SKTexture(imageNamed: "block")

        
    }
    
    //pressed wrong side
    func lose() {
        //print("you lose")
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).color = .red
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            //print(""t)
            move(location: t.location(in: self))
        }
        
    }
    
    var time: TimeInterval = 0
    var startTime: TimeInterval = 0
    var second = 0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //intiate the start time
        if startTime == 0 {
            startTime = currentTime
        }
        
        time = (currentTime - startTime)
        
        //this function happens every second
        if (Int(floor(Double(time))) > second) {
            second += 1
            
            //If player started, then the catcher starts moving
            if playerStarted {
                currentCatcherPosition += catcherSpeed
            }
            
            if currentCatcherPosition > currentNumberPosition {
                lose()
            }
        }
        
        
        //if the player tapped the screen, start the timer
        if currentNumberPosition != 0 {
            
            //wait 2 seconds and go
            if second > 1 {
                playerStarted = true
            }
            
        }
        
        
    }
    
}
