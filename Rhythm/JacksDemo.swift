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
    
    var data = DataEncoder(lastLogonDate: Date(), highScore: 0, currency: 0)
    
    var changecurrentposition = true
    var playerStarted: Bool = false
    
    var player = SKSpriteNode()
    var tileMaster = SKNode()
    var menu = SKNode()
    var scoreNode = SKLabelNode()
    var highScoreNode = SKLabelNode()
    
    var currentTilePosition = 1
    var timeSinceStart = 0
    var currentCatcherPosition = 0
    var catcherSpeed = 0.05
    var tileSize: CGFloat = 75
    var score:Int = 0
    var highscore:Int = 0
    
    override func sceneDidLoad() {
        
        //load data
        if let loadedData = loadData() {
            self.data = loadedData
        }
        else {
            print("couldnt load")
        }
        highscore = data.highScore
        if let lastLogonDate = data.getLastLogonDate(){
            
            if lastLogonDate < Date() {
                //print(lastLogonDate)
                //print(Date())
            }
            
            print(lastLogonDate.addingTimeInterval(TimeInterval(86400)))
            print(Date())
            
            if lastLogonDate.addingTimeInterval(TimeInterval(86400)) < Date() {
                reward()
            }
        }
        
        //save data
        data.setLastLogonDate(lld: Date())
        saveData()
        
        //load the stuff that doesn't need resetting
        self.backgroundColor = .black
        scoreNode.text = String(score)
        scoreNode.color = UIColor.white
        scoreNode.position = CGPoint(x:300 ,y: 600)
        scoreNode.fontSize = 50
        
        player.color = UIColor.gray
        player.size = CGSize(width: 30, height: 30)
        player.zPosition = 10
        
        highScoreNode.text = String(highscore)
        highScoreNode.fontColor = UIColor.red
        highScoreNode.position = CGPoint(x:0 ,y: 600)
        highScoreNode.fontSize = 50
        highScoreNode.fontName = "KannadaSangamMN"
        
        showMenu()
        
        menu.addChild(highScoreNode)
        
        self.addChild(scoreNode)
        self.addChild(player)
        
        //loads stuff that can be reset
        load()
        
    }
    
    func reward() {
        print("reward")
    }
    
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: DataEncoder.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadData() -> DataEncoder? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DataEncoder.ArchiveURL.path) as? DataEncoder
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
        
        player.position = CGPoint(x: 0 ,y: -200)
        currentTilePosition = 1
        currentCatcherPosition = 0
        timeSinceStart = 0
        playerStarted = false
    }
    
    //move
    func move(location: CGPoint) {
        
        let currentTileId = (tileMaster.children[currentTilePosition] as! Tile).getTileId()
        if (currentTileId == 0) {
            tileMaster.run(SKAction.moveBy(x: tileSize, y: -tileSize, duration: 0.15))
            
            if location.x <= 0 {
                success()
            }
            
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
            let startTile = Tile(color: UIColor.blue, size: CGSize(width: tileSize, height: tileSize))
            startTile.setTileId(id: -1)
            startTile.position = CGPoint(x: 0 ,y: 0)
            tileMaster.addChild(startTile)
            return
        }
        
        //initialize tile
        //let tile = SKSpriteNode(color: UIColor.white, size: CGSize(width: tileSize, height: tileSize))
        
        //check to see if tile should be spawned to the left or right
        if tileId == 1 {
            //right
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x + tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        } else if tileId == 0 {
            //left
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        } else if tileId == 2 {
            tile.color = .brown
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - tileSize, y:((tileMaster.children.last?.position)!.y + tileSize))
        }
        //if there are more than 100 tiles, remove tiles from bottom
        if tileMaster.children.count > 100 {
            changecurrentposition = false
            tileMaster.children.first?.removeFromParent()
            currentCatcherPosition -= 1
        }
        
        tileMaster.addChild(tile)
    }
    
    //pressed correct side
    func success() {
        //update score
        score += 1
        scoreNode.text = String(score)
        
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).color = .green
        
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
    var sixty:Double = 1/60
    var catcherUpdate:Double = 0.0
    
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
