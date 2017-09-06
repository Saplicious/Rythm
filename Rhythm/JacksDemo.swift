//
//  JacksDemo.swift
//  Rhythm
//
//  Created by Jack Jiang on 8/31/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

//TODO: Add a red tile catching up to the player depending on the time

import Foundation

import SpriteKit
import GameplayKit

class JacksDemo: SKScene {
    
    var player = SKSpriteNode()
    
    var tileMaster = SKNode()
    var arrayOfNumbers: [Int] = [-1]
    var currentNumberPosition = 0
    var currentTilePosition = 0
    var tileSize: CGFloat = 100
    
    var scoreNode = SKLabelNode()
    var score = 0
    
    override func sceneDidLoad() {
        load()
        self.backgroundColor = .black
    }
    
    //generate numbers 0,1
    func generate() {
        let rn = Int(arc4random_uniform(2))
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
            count += 1
        }
        
        self.addChild(tileMaster)
        
        //load the scoreNode
        scoreNode.text = String(score)
        scoreNode.color = UIColor.white
        scoreNode.position = CGPoint(x:300 ,y: 600)

        player.color = UIColor.gray
        player.size = CGSize(width: 30, height: 30)
        player.position = CGPoint(x: 0 ,y: -200)
        self.addChild(scoreNode)
        self.addChild(player)
    }
    
    //move
    func move(location: CGPoint) {
        
        if (arrayOfNumbers[currentNumberPosition] == 0) {
            //tileMaster.position = CGPoint(x: tileMaster.position.x,y: tileMaster.position.y - tileSize)
            tileMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            
        } else if (arrayOfNumbers[currentNumberPosition] == 1) {
            //tileMaster.position = CGPoint(x: tileMaster.position.x - tileSize,y: tileMaster.position.y - tileSize)
            tileMaster.run(SKAction.moveBy(x: -tileSize, y: -tileSize, duration: 0.15))
            
        } else if (arrayOfNumbers[currentNumberPosition] == -1) {
            //tileMaster.position = CGPoint(x: tileMaster.position.x,y: tileMaster.position.y - tileSize)
            
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
        
        player.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 80, duration: 0.075),SKAction.moveBy(x: 0, y: -80, duration: 0.075)]))
        //tileMaster.position = CGPoint(x: tileMaster.position.x ,y: tileMaster.position.y - tileSize)
    }
    
    //generate tiles
    func spawnTile() {
        
        //very first tile
        if tileMaster.children.count == 0 {
            let startTile = SKSpriteNode(color: UIColor.red, size: CGSize(width: tileSize, height: tileSize))
            startTile.position = CGPoint(x: 0 ,y: -200)
            tileMaster.addChild(startTile)
            return
        }
        
        //initialize tile
        let tile = SKSpriteNode(color: UIColor.green, size: CGSize(width: tileSize, height: tileSize))
        
        //check to see if tile should be spawned to the left or right
        if arrayOfNumbers.last! == 1 {
            //right
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x + tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        } else if arrayOfNumbers.last! == 0 {
            //left
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        }
        
        tileMaster.addChild(tile)
        
        //if there are more than 200 tiles, remove tiles from bottom
        if tileMaster.children.count > 200 {
            tileMaster.children.first?.removeFromParent()
        }
    }
    
    //pressed correct side
    func success() {
        //update score
        score += 1
        scoreNode.text = String(score)
        
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).color = .white
        
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
