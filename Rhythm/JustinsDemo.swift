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
    var pausedState = false
    var currentNumberPosition = 0
    var currentTilePosition = 0
    //position per second
    var currentCatcherPosition = -1
    var catcherSpeed = 0
    var tileSize: CGFloat = 206
    var tileSize2: CGFloat = 258
    let ring = SKSpriteNode(imageNamed: "ring")
    var scoreNode:SKLabelNode = SKLabelNode(fontNamed: "bold")
    var score = 0
    
    var layer = 1000000
    
    var buttonMaster = SKNode()
    

    
    //speed of blocks and player moving downwards
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
        load()
        //add gestures
        addButtons()
    
        let background = SKSpriteNode(imageNamed: "bg5")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 0
        addChild(background)
        
        
        ring.position = CGPoint(x: 0, y: 0)
        ring.size = CGSize(width: self.size.width, height: self.size.height)
        ring.zPosition = CGFloat(self.layer + 208)
        addChild(ring)

        
        player.zPosition = CGFloat(layer + 1000)

    

    }
    func addButtons() {
        
        pausedState = true
        let settings = SKSpriteNode(imageNamed: "setting")
        settings.position = CGPoint(x: -self.size.width * 0.21, y: -self.size.height * 0.33)
        settings.name = "settings"
        let play = SKSpriteNode(imageNamed: "play")
        play.position = CGPoint(x: 0, y: -self.size.height * 0.33)
        play.name = "play"
        let store = SKSpriteNode(imageNamed: "store")
        store.position = CGPoint(x: self.size.width * 0.21, y: -self.size.height * 0.33)
        store.name = "store"
        self.addChild(buttonMaster)
        buttonMaster.zPosition = CGFloat(layer + 2000)
        buttonMaster.addChild(settings)
        buttonMaster.addChild(play)
        buttonMaster.addChild(store)
        
        
    }
    func deleteButtons(i: Int) {
        
        pausedState = false
        if i == 0{
        
            move(location: 4)
        
        }
        buttonMaster.run(SKAction.fadeOut(withDuration: 0.5))
        buttonMaster.run(SKAction.moveBy(x: 0, y: -200, duration: 0.6))
    }
    
    //generate numbers 0,1
    func generate() {
        let rn = Int(arc4random_uniform(8))
        if rn == 4 || rn == 5 {
            arrayOfNumbers.append(0)
        }
        else if rn == 6 || rn == 7 {
            arrayOfNumbers.append(1)
        }
        else {
            arrayOfNumbers.append(rn)
        }
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

        
        scoreNode.fontSize = 60
        scoreNode.text = ("\(score)")
        scoreNode.position = CGPoint(x: -self.size.width * 0.34, y: self.size.height * 0.38)
        scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreNode.zPosition = 1000000000
        scoreNode.fontColor = SKColor(red: 75/255, green: 70/255, blue: 62/255, alpha: 1.0)
        
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 81, height: 138)
        player.position = CGPoint(x: 0 ,y: -110)
        
        self.addChild(scoreNode)
        self.addChild(player)
        
        
    }
    
    //move
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if pausedState == false{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                move(location: 0)
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                move(location: 3)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                move(location: 1)
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                move(location: 2)
            default:
                print("Swiped up")
                break
                }
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            if (buttonMaster.childNode(withName: "play")?.contains(touch.location(in: self)))!{
                
                buttonMaster.childNode(withName: "play")?.alpha = 0.5
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
       
        for touch in touches {
            
            if (buttonMaster.childNode(withName: "play")?.contains(touch.location(in: self)))!{
                

                buttonMaster.childNode(withName: "play")?.run(SKAction.moveBy(x: 0, y: -500, duration: 0))
                deleteButtons(i: 0)
                
                
            }
        }
    }
    
    
    
    
    func move(location: Int) {
        
        
        
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
    
        if location == 0 {
            //move left
            print("moved right")
            if arrayOfNumbers[currentNumberPosition] == 0 {
                success()
            } else {
                lose()
            }
            
        } else if location == 1{
            //move right
            print("moved left")
            if arrayOfNumbers[currentNumberPosition] == 1 {
                success()
            } else {
                lose()
            }
            
        } else if location == 2{
            //move up
            print("moved up")
            if arrayOfNumbers[currentNumberPosition] == 2 {
                success()
            } else {
                lose()
            }
            
        } else if location == 3{
            //move down
            print("moved down")
            if arrayOfNumbers[currentNumberPosition] == 3 {
                success()
            } else {
                lose()
            }
            
        }  else if location == 4{

            print("STARTED")
            let b1 = SKTexture(imageNamed: "block")
            let b2 = SKTexture(imageNamed: "dblock1")
            let b3 = SKTexture(imageNamed: "dblock2")
            let b4 = SKTexture(imageNamed: "dblock3")
            let b5 = SKTexture(imageNamed: "block_dark")
            
            
            
            let animate = SKAction.sequence([
                SKAction.animate(with: [b1, b2, b3 ,b4, b5], timePerFrame: 0.05)
                ])
            (tileMaster.children[currentTilePosition] as! SKSpriteNode).run(animate)
            
            
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
            self.ring.zPosition = CGFloat(self.layer + 208)
            },SKAction.moveBy(x: 0, y: -80, duration: 0.075)]))
        //tileMaster.position = CGPoint(x: tileMaster.position.x ,y: tileMaster.position.y - tileSize)
        
        
    }
    
    //generate tiles
    func spawnTile() {
        

        //very first tile
        if tileMaster.children.count == 0 {
            let tile2 = SKSpriteNode(imageNamed: "block")
            tile2.size = CGSize(width: tileSize, height: tileSize2)
            tile2.position = CGPoint(x: 0 ,y: -200)
            tile2.zPosition = CGFloat(layer)
            layer = layer - 2
            tileMaster.addChild(tile2)
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

        
    }
    
    //pressed wrong side
    func lose() {
        print("you lose")
        let b1 = SKTexture(imageNamed: "block")
        let b2 = SKTexture(imageNamed: "dblock1")
        let b3 = SKTexture(imageNamed: "dblock2")
        let b4 = SKTexture(imageNamed: "dblock3")
        let b5 = SKTexture(imageNamed: "block_dark")
        
        
        
        let animate = SKAction.sequence([
            SKAction.animate(with: [b1, b2, b3 ,b4, b5], timePerFrame: 0.05)
            ])
        (tileMaster.children[currentTilePosition] as! SKSpriteNode).run(animate)
    }
    func disappear(i: Int) {
        print("you lose")
        let b1 = SKTexture(imageNamed: "block")
        let b2 = SKTexture(imageNamed: "dblock1")
        let b3 = SKTexture(imageNamed: "dblock2")
        let b4 = SKTexture(imageNamed: "dblock3")
        let b5 = SKTexture(imageNamed: "block_dark")
        
        
        
        let animate = SKAction.sequence([
            SKAction.animate(with: [b1, b2, b3 ,b4, b5], timePerFrame: 0.05)
            ])
        (tileMaster.children[i] as! SKSpriteNode).run(animate)
        (tileMaster.children[i] as! SKSpriteNode).run(SKAction.fadeOut(withDuration: 5.0))
        (tileMaster.children[i] as! SKSpriteNode).run(SKAction.moveBy(x: 0, y: -500, duration: 5.0))
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
                disappear(i: currentCatcherPosition)
            }
            
            if currentCatcherPosition > currentNumberPosition {
                lose()
            }
        }
        
        
        //if the player tapped the screen, start the timer
        if currentNumberPosition != 0 {
            
            //wait 2 seconds and go
            if second > 2 {
                playerStarted = true
            }
            
        }
        
        
    }
    
}
