//
//  MergedScene2.swift
//  Rhythm
//
//  Created by Jack Jiang on 9/21/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit
import os.log

class MergedScene2: SKScene {
    
    //Data
    var data = DataEncoder(lastLogonDate: Date(), highScore: 0)
    
    //Booleans
    var changecurrentposition = true
    var playerStarted: Bool = false
    var pausedState: Bool = true
    
    //SKNodes
    var player = SKSpriteNode()
    var tileMaster = SKNode()
    var menu = SKNode()
    var scoreNode = SKLabelNode(fontNamed: "bold")
    var highScoreNode = SKLabelNode()
    var topLabel = SKLabelNode()
    var bottomLabel = SKLabelNode()
    let ring = SKSpriteNode(imageNamed: "ring")
    
    //Variables
    var currentTilePosition = 1
    var timeSinceStart = 0
    var currentCatcherPosition = 0
    var catcherSpeed = 0.02
    var tileWidth: CGFloat = 206
    var tileHeight: CGFloat = 258
    var score:Int = 0
    var highscore:Int = 0
    var layer = 100000
    
    
    // ********* MOVED TO SCENE ************
    
    override func didMove(to view: SKView) {
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    override func sceneDidLoad() {
        
        //load data
        if let loadedData = loadData() {
            self.data = loadedData
        }
        else {
            print("couldnt load")
        }
        
        //set highscore to highscore in data
        highscore = data.highScore
        
        
        //Logon date for rewards still *WIP*
        if let lastLogonDate = data.getLastLogonDate(){
            
            if lastLogonDate < Date() {
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
        
            //initialize background
        let background = SKSpriteNode(imageNamed: "bg6")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 0
        addChild(background)
        
            //initialize ring
        
        ring.position = CGPoint(x: 0, y: 0)
        ring.size = CGSize(width: self.size.width, height: self.size.height)
        ring.zPosition = CGFloat(self.layer + 208)
        addChild(ring)
        
        
            //initialize scorenode
        scoreNode.fontSize = 60
        scoreNode.text = ("\(score)")
        scoreNode.position = CGPoint(x: -self.size.width * 0.34, y: self.size.height * 0.38)
        scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreNode.zPosition = 100000000
        scoreNode.fontColor = SKColor(red: 75/255, green: 70/255, blue: 62/255, alpha: 1.0)
        scoreNode.alpha = 0.0
        
            //initialize player
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 81 , height: 138)
        player.position = CGPoint(x: 0 ,y: 120)
        player.zPosition = CGFloat(layer + 208)
        
        //add the menu to the scene
            //initialize highScoreNode
        highScoreNode.text = String("\(highscore)")
        highScoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highScoreNode.fontColor = SKColor(red: 75/255, green: 70/255, blue: 62/255, alpha: 1.0)
        highScoreNode.position = CGPoint(x: self.size.width * -0.34, y: self.size.height * 0.38)
        highScoreNode.fontSize = 60
        highScoreNode.fontName = "bold"
        
        topLabel.text = String("h i g h s c o r e")
        topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        topLabel.fontColor = SKColor(red: 75/255, green: 70/255, blue: 62/255, alpha: 1.0)
        topLabel.position = CGPoint(x: self.size.width * -0.34, y: self.size.height * 0.35)
        topLabel.fontSize = 30
        topLabel.fontName = "bold"
        topLabel.zPosition = CGFloat(layer + 1000000)
        
            //initialize settings button
        let settings = SKSpriteNode(imageNamed: "setting")
        settings.position = CGPoint(x: -self.size.width * 0.21, y: -self.size.height * 0.33)
        settings.name = "settings"
        
            //initialize play button
        let play = SKSpriteNode(imageNamed: "play")
        play.position = CGPoint(x: 0, y: -self.size.height * 0.33)
        play.name = "play"
        
            //initialize store button
        let store = SKSpriteNode(imageNamed: "store")
        store.position = CGPoint(x: self.size.width * 0.21, y: -self.size.height * 0.33)
        store.name = "store"
        
            //add everything
        menu.zPosition = CGFloat(layer + 100)
        menu.addChild(settings)
        menu.addChild(play)
        menu.addChild(store)
        
        showMenu()
        menu.addChild(highScoreNode)
        
        self.addChild(topLabel)
        self.addChild(scoreNode)
        self.addChild(player)
        
        //loads stuff that can be reset
        load()
        
    }
    
    // ********* END OF MOVED TO SCENE STUFF ************
    
    //once the scene loads
    func load() {
        
        
        layer = 100000
        score = 0
        scoreNode.text = String(score)
        
        //spawn 30 tiles
        for _ in 1...30{
            spawnTile()
        }
        
        //intialize tilemaste
        //tileMaster.position = CGPoint(x:0, y: -200)
        print(tileMaster)
        self.addChild(tileMaster)
        
        player.position = CGPoint(x: 0 ,y: -123)
        player.zPosition = CGFloat(layer + 208)
        currentTilePosition = 1
        currentCatcherPosition = 0
        timeSinceStart = 0
        playerStarted = false
        changecurrentposition = true
    }
    
    //Spawns a Randomly Generated Tile
    func spawnTile() {
        
        //initialize tile
        var tile = Tile(imageNamed: "block")
        tile.size = CGSize(width: tileWidth, height: tileHeight)
        
        //very first tile's properties are set
        if tileMaster.children.count == 0 {
            tile = Tile(imageNamed: "block_light")
            tile.size = CGSize(width: tileWidth, height: tileHeight)
            tile.position = CGPoint(x: 0 ,y: -200)
            tile.zPosition = CGFloat(layer)
            tileMaster.addChild(tile)
            return
        }
        
        // gets random number and sees which tile to make
        let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
        var tileId = 0
        
        //chance of getting each block 25%
        if 0 <= rn && rn < 0.25 {
            //block 1
            tileId = 0
        } else if 0.25 <= rn && rn < 0.5 {
            //block 2
            tileId = 1
        } else if 0.5 <= rn && rn < 0.75 {
            //block 3
            tileId = 2
        } else {
            //block 4
            tileId = 3
        }
        
        //remember to set the tile's id to tileId
        tile.setTileId(id: tileId)
        
        //Where should the tiles be spawned? (right,left,up,down)
        if tileId == 0 {
            //right
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x + (tileWidth/2) - 2.5, y:((tileMaster.children.last?.position)!.y + (tileHeight / 3.4)))
        } else if tileId == 1 {
            //left
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - (tileWidth / 2) + 2.5, y:((tileMaster.children.last?.position)!.y + (tileHeight / 3.4)))
        } else if tileId == 2 {
            //up
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x + (tileWidth / 2) - 2.5, y:((tileMaster.children.last?.position)!.y + (tileHeight/1.5)))
        } else if tileId == 3 {
            //down
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - (tileWidth / 2) + 2.5, y:((tileMaster.children.last?.position)!.y - 25))
        }
        
        //if there are more than 100 tiles, remove tiles from bottom
        if tileMaster.children.count > 100 {
            changecurrentposition = false
            tileMaster.children.first?.removeFromParent()
            currentCatcherPosition -= 1
        }
        
        //set the tile's zposition
        tile.zPosition = CGFloat((tileMaster.children.last?.zPosition)! - CGFloat(2))
        
        //adds the child to tilemaster
        tileMaster.addChild(tile)
        
    }
    
    //this will be the daily reward
    func reward() {
        print("reward")
    }
    
    //save data
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: DataEncoder.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    //load data
    private func loadData() -> DataEncoder? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DataEncoder.ArchiveURL.path) as? DataEncoder
    }
    
    //move
    func move(location: Int) {
        print(currentTilePosition)
        //depending on what the current tile's id is checks to see if the right gesture was made
        let currentTileId = (tileMaster.children[currentTilePosition] as! Tile).getTileId()
        if (currentTileId == -1) {
            success()
        } else if (currentTileId == 0) {
            //move left
            tileMaster.run(SKAction.moveBy(x: (-tileWidth / 2) + 2.5, y: -tileHeight / 3.4, duration: 0.20))
            
            if location == 0 {
                success()
            } else {
                lose()
                return
            }
            
        } else if (currentTileId == 1) {
            //move right
            tileMaster.run(SKAction.moveBy(x: (tileWidth / 2) - 2.5, y: -tileHeight / 3.4, duration: 0.20))
            
            if location == 1 {
                success()
            } else {
                lose()
                return
            }
            
        } else if (currentTileId == 2) {
            //move up
            tileMaster.run(SKAction.moveBy(x: -tileWidth / 2  + 2.5, y: -tileHeight / 1.5, duration: 0.20))
            
            if location == 2 {
                success()
            } else {
                lose()
                return
            }
            
        } else if (currentTileId == 3) {
            //move down
            tileMaster.run(SKAction.moveBy(x: tileWidth / 2 - 2.5, y: 25, duration: 0.20))
            
            if location == 3 {
                success()
            } else {
                lose()
                return
            }
            
        }
        
        //spawns the tile
        spawnTile()
        
        //if net tiles are going up
        if changecurrentposition {
            currentTilePosition += 1
        }
        
        //animate the player
        if player.position.y < 200{
            player.run(SKAction.moveBy(x: 0, y: 0, duration: 0.20))
            tileMaster.run(SKAction.moveBy(x: 0, y: 0, duration: 0.20))
        }
        else
        {
            player.run(SKAction.moveBy(x: 0, y: 0, duration: 0.20))
            tileMaster.run(SKAction.moveBy(x: 0, y: 0, duration: 0.20))
        }
        
        player.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 80, duration: 0.10),SKAction.run {
            self.player.zPosition = CGFloat(self.tileMaster.children[self.currentTilePosition - 1].zPosition + CGFloat(1))
            self.ring.zPosition = CGFloat(self.tileMaster.children[self.currentTilePosition].zPosition - 1)
            },SKAction.moveBy(x: 0, y: -80, duration: 0.10)]))
        print(player.zPosition)
        print(tileMaster.children[self.currentTilePosition].zPosition)
        
    }
    
    
    //pressed correct side
    func success() {
        //update score
        score += 1
        scoreNode.text = String(score)
        
        //*** ANIMATION: LIGHT BLUE BLOCKS ***
        let b1 = SKTexture(imageNamed: "block")
        let b2 = SKTexture(imageNamed: "block1")
        let b3 = SKTexture(imageNamed: "block2")
        let b4 = SKTexture(imageNamed: "block3")
        let b5 = SKTexture(imageNamed: "block4")
        let b6 = SKTexture(imageNamed: "block5")
        let b7 = SKTexture(imageNamed: "block6")
        let b8 = SKTexture(imageNamed: "block7")
        let b9 = SKTexture(imageNamed: "block8")
        let b10 = SKTexture(imageNamed: "block9")
        let b11 = SKTexture(imageNamed: "block_light")
        
        
        let animate = SKAction.sequence([
            SKAction.animate(with: [b1, b2, b3 ,b4 ,b5, b6 ,b7 ,b8, b9, b10, b11, b11, b10, b9], timePerFrame: 0.06)
            ])
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).run(animate)
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).color = .white
        //*** END ANIMATION: LIGHT BLUE BLOCKS ***
        
    }
    
    func fall() {
        // *** ANIMATION: FALLING BLOCKS ***
        let b1 = SKTexture(imageNamed: "block")
        let b2 = SKTexture(imageNamed: "dblock1")
        let b3 = SKTexture(imageNamed: "dblock2")
        let b4 = SKTexture(imageNamed: "dblock3")
        let b5 = SKTexture(imageNamed: "block_dark")
        
        let animate = SKAction.sequence([
            SKAction.animate(with: [b1, b2, b3 ,b4, b5], timePerFrame: 0.05)
            ])
        (tileMaster.children[currentCatcherPosition] as! SKSpriteNode).run(animate)
        (tileMaster.children[currentCatcherPosition] as! SKSpriteNode).run(SKAction.fadeOut(withDuration: 5.0))
        (tileMaster.children[currentCatcherPosition] as! SKSpriteNode).run(SKAction.moveBy(x: 0, y: -500, duration: 5.0)) {
            if self.currentCatcherPosition >= (self.currentTilePosition - 1) {
                self.lose()
            }
        }
        // *** END ANIMATION: FALLING BLOCKS ***
    }
    
    //pressed wrong side or blue tile catches up to the player
    func lose() {
        
        //*** ANIMATION: DARK BLOCK ***
        let b1 = SKTexture(imageNamed: "block")
        let b2 = SKTexture(imageNamed: "dblock1")
        let b3 = SKTexture(imageNamed: "dblock2")
        let b4 = SKTexture(imageNamed: "dblock3")
        let b5 = SKTexture(imageNamed: "block_dark")
        
        
        
        let animate = SKAction.sequence([
            SKAction.animate(with: [b1, b2, b3 ,b4, b5], timePerFrame: 0.05)
            ])
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).run(animate)
        //*** END ANIMATION: DARK BLOCK ***
        
        //If score is higher than highscore, set highscore to score and saves highscore
        if score > highscore {
            highscore = score
        }
        data.setHighScore(hs: highscore)
        
        //make ring right layer
        self.ring.zPosition = CGFloat(layer)
        
        //reset the game
        showMenu()
        saveData()
        resetGame()
    }
    
    func resetGame() {
        tileMaster.removeFromParent()
        tileMaster = SKNode()
        load()
        //currentTilePosition = 0
        //print("current tile position\(currentTilePosition)")
    }
    
    func showMenu() {
        
        pausedState = true
        highScoreNode.text = String(highscore)
        highScoreNode.alpha = 1.0
        topLabel.text = "h i g h s c o r e"
        scoreNode.alpha = 0.0
        self.addChild(menu)
    }
    
    func hideMenu() {
        
        topLabel.text = "s c o r e"
        pausedState = false
        scoreNode.alpha = 1.0
        menu.removeFromParent()
    }
    
    
    
    //******* TOUCH RESPONSES ********
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            if (menu.childNode(withName: "play")?.contains(touch.location(in: self)))!{
                
                hideMenu()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for touch in touches {
            
            if (menu.childNode(withName: "play")?.contains(touch.location(in: self)))!{
                
            }
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if pausedState == false{
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    print("right")
                    move(location: 0)
                case UISwipeGestureRecognizerDirection.down:
                    print("down")
                    move(location: 3)
                case UISwipeGestureRecognizerDirection.left:
                    print("left")
                    move(location: 1)
                case UISwipeGestureRecognizerDirection.up:
                    print("up")
                    move(location: 2)
                default:
                    
                    break
                }
            }
            
        }
        
    }
    
    // ******** END OF TOUCH RESPONSES *********
    
    
    
    
    
    
    
    
    
    // ******** UPDATE FUNCTION ***********
    
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
        
        //(tileMaster.children[currentCatcherPosition] as! SKSpriteNode).color = .blue
        
        //this function happens every second
        if (Int(floor(Double(time))) > second) {
            second += 1
            
            if currentTilePosition != 1 {
                timeSinceStart += 1
            }
        }
        if score == 0{
            
            catcherSpeed = 0.02
            
        }
        if score == 10{
            
            catcherSpeed = 0.03
            
        }
        if score == 20{
            
            catcherSpeed = 0.035
            
        }
        if score == 30{
            
            catcherSpeed = 0.04
            
        }
        if score == 40{
            
            catcherSpeed = 0.045
            
        }
        if score == 50{
            
            catcherSpeed = 0.050
            
        }
        if score == 60{
            
            catcherSpeed = 0.055
            
        }
        if score == 70{
            
            catcherSpeed = 0.060
            
        }
        if score == 80{
            
            catcherSpeed = 0.065
            
        }
        
        
        
        //happens every 1/60 second
        if (time > sixty) {
            sixty += 1/60
            
            if playerStarted {
                catcherUpdate += catcherSpeed
                if (catcherUpdate > 1){
                    if currentCatcherPosition >= (currentTilePosition - 1) {
                        pausedState = true
                    }
                    fall()
                    currentCatcherPosition += 1
                    catcherUpdate = 0.0
                }
            }
            
            if (currentTilePosition - currentCatcherPosition) > 10 {
                currentCatcherPosition = currentTilePosition - 10
            }
        }
        
        //if the player tapped the screen, start the timer
        if currentTilePosition != 1 {
            
            //menu.removeFromParent()
            
            //wait 3 seconds and go
            if timeSinceStart > 0 {
                playerStarted = true
            }
            
        }
        
        
    }
    
    // ******** END OF UPDATE FUNCTION **********
    
}
