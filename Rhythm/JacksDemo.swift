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
import os.log

class JacksDemo: SKScene {
    
    var player = SKSpriteNode()
    var playerStarted: Bool = false
    
    var player = SKSpriteNode()
    var tileMaster = SKNode()
    //var shadowMaster = SKNode()
    
    var arrayOfNumbers: [Int] = [-1]
    var currentNumberPosition = 0
    var currentTilePosition = 0
    //position per second
    var currentCatcherPosition = 0
    var catcherSpeed = 0
    var tileSize: CGFloat = 100
    var tileSize2: CGFloat = 100
    
    var scoreNode = SKLabelNode()
    var score = 0
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
    
    //generate numbers 0,1,2,3
    func generate() {
        let rn = Int(arc4random_uniform(4))
        arrayOfNumbers.append(rn)
    }
    
    //once the scene loads
    func load() {
        //add the first tile
        generateTile(maxTileId: 0)
        //catcherSpeed = 0.0001
        
        //generate 100 tiles
        var count = 0
        for _ in 1...20{
            generateTile(maxTileId: 1)
            count += 1
        }
        
        tileMaster.position = CGPoint(x:0, y: -200)
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
        player.position = CGPoint(x: 0 ,y: -180)
        player.zPosition = 4
        self.addChild(scoreNode)
        self.addChild(player)
    }
    
    //move
    func move(location: CGPoint) {
        
        if (arrayOfNumbers[currentNumberPosition] == 0) {
    
            tileMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            //shadowMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            
            
        } else if (arrayOfNumbers[currentNumberPosition] == 1) {


            tileMaster.run(SKAction.moveBy(x: -tileSize, y: -tileSize, duration: 0.15))
            //shadowMaster.run(SKAction.moveBy(x: -tileSize, y: -tileSize, duration: 0.15))

            
        } else if (currentTileId == 1) {
            tileMaster.run(SKAction.moveBy(x: -tileSize, y: -tileSize, duration: 0.15))
            
            if location.x > 0 {
                success()
            }
            
        } else if (currentTileId == -1) {
            
            success()
            
        } else if (currentTileId == 2) {
            tileMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            
            if location.x <= 0 {
                success()
            }
        }

        //which tiles to spawn depending on score
        switch score {
        case 20..<200:
            generateTile(maxTileId: 2)
        case 200..<1000:
            generateTile(maxTileId: 1)
        default:
            generateTile(maxTileId: 1)
        }
        if changecurrentposition {
            currentTilePosition += 1
            
        }
        
        player.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 80, duration: 0.075),SKAction.moveBy(x: 0, y: -80, duration: 0.075)]))
        //tileMaster.position = CGPoint(x: tileMaster.position.x ,y: tileMaster.position.y - tileSize)
    }
    
    //generate random tile from numbers 0...maxTileId
    func generateTile(maxTileId: Int) {
        let tileId = Int(arc4random_uniform(UInt32(maxTileId+1)))
        let tile = Tile(color: UIColor.white, size: CGSize(width: tileSize, height: tileSize))
        
        tile.setTileId(id: tileId)
        spawnTile(tile: tile)
    }
    
    //generate tiles
    func spawnTile(tile: Tile) {
        
        let tileId = tile.getTileId()
        
        //very first tile
        if tileMaster.children.count == 0 {
            let startTile = SKSpriteNode(color: UIColor.blue, size: CGSize(width: tileSize, height: tileSize2))
            startTile.position = CGPoint(x: 0 ,y: -200)
            tileMaster.addChild(startTile)
            return
        }
        
        //initialize tile

        let tile2 = SKSpriteNode(imageNamed: "concrete")
        tile2.size = CGSize(width: tileSize, height: tileSize2)
        
        let shadow = SKSpriteNode(imageNamed: "shadow")
        shadow.size = CGSize(width: tileSize + (tileSize * (8/6)), height: tileSize2 + (tileSize * (8/6)))
        shadow.alpha = 0.3
        
        //check to see if tile should be spawned to the left or right
        if tileId == 1 {
            //right
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x + tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
            shadow.position = CGPoint(x: (tileMaster.children.last?.position)!.x + tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
            
        } else if arrayOfNumbers.last! == 0 {
            //left
            tile2.position = CGPoint(x: (tileMaster.children.last?.position)!.x - tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
            shadow.position = CGPoint(x: (tileMaster.children.last?.position)!.x - tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        }
        
        tileMaster.addChild(tile2)
        //shadowMaster.addChild(shadow)
        
        //if there are more than 200 tiles, remove tiles from bottom
        if tileMaster.children.count > 200 {
            tileMaster.children.first?.removeFromParent()
            currentCatcherPosition -= 1
        }
        //if shadowMaster.children.count > 200 {
          //  shadowMaster.children.first?.removeFromParent()
        //}
    }
    
    //pressed correct side
    func success() {
        //update score
        score += 1
        scoreNode.text = String(score)
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).texture = SKTexture(imageNamed: "concrete")
        
        //(tileMaster.children[currentTilePosition] as! SKSpriteNode).color = .green
        
    }
    
    //pressed wrong side or blue tile catches up to the player
    func lose() {
        
        if score > highscore {
            highscore = score
        }
        showMenu()
        
        data.setHighScore(hs: highscore)
        saveData()
        resetGame()
    }
    
    func resetGame() {
        tileMaster.removeFromParent()
        tileMaster = SKNode()
        score = 0
        scoreNode.text = String(score)
        load()
    }
    
    func showMenu() {
        highScoreNode.text = String(highscore)
        self.addChild(menu)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
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
        
        (tileMaster.children[currentCatcherPosition] as! SKSpriteNode).color = .blue
        
        //this function happens every second
        if (Int(floor(Double(time))) > second) {
            second += 1
            
            if currentTilePosition != 1 {
                timeSinceStart += 1
            }
        }
        
        
        //happens every 1/60 second
        if (time > sixty) {
            sixty += 1/60
            
            if playerStarted {
                catcherUpdate += catcherSpeed
                if (catcherUpdate > 1){
                    currentCatcherPosition += 1
                    catcherUpdate = 0.0
                }
            }
            
            if (currentTilePosition - currentCatcherPosition) > 15 {
                currentCatcherPosition = currentTilePosition - 15
            }
        }

        
        if currentCatcherPosition >= currentTilePosition {
            lose()
        }
        
        //if the player tapped the screen, start the timer
        if currentTilePosition != 1 {
            
            menu.removeFromParent()
            
            //wait 3 seconds and go
            if timeSinceStart > 3 {
                playerStarted = true
            }
            
        }
        
        
    }
    
}
