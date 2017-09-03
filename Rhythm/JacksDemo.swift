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
    
    var player = SKSpriteNode()
    var tileMaster = SKNode()
    var arrayOfNumbers: [Int] = [-1]
    var currentPosition = 0
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
    
    //once the scene loads
    func load() {
        //add the first tile
        spawnTile()
        
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
        
        print(arrayOfNumbers)
        
        self.addChild(tileMaster)
    }
    
    //move
    func move(location: CGPoint) {
        if (location.x <= 0) {
            //move left
            print("moved left")
            if arrayOfNumbers[currentPosition] != 1 {
                success()
            } else {
                lose()
            }
            
        } else {
            //move right
            print("moved right")
            if arrayOfNumbers[currentPosition] != 0 {
                success()
            } else {
                lose()
            }
            
        }
        generate()
        spawnTile()
        currentPosition += 1
        print(arrayOfNumbers)
        tileMaster.position = CGPoint(x: tileMaster.position.x,y: tileMaster.position.y - 10)
    }
    
    //generate tiles
    func spawnTile() {
        
        print(arrayOfNumbers.last)
        
        //very first tile
        if tileMaster.children.count == 0 {
            let startTile = SKSpriteNode(color: UIColor.red, size: CGSize(width: 10, height: 10))
            startTile.position = CGPoint(x: 0 ,y: 0)
            tileMaster.addChild(startTile)
            return
        }
        
        let tile = SKSpriteNode(color: UIColor.green, size: CGSize(width: 10, height: 10))
        
        if arrayOfNumbers.last! == 1 {
            //right
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x + 10, y:((tileMaster.children.last?.position)!.y + 10))
        } else if arrayOfNumbers.last! == 0 {
            //left
            tile.position = CGPoint(x: (tileMaster.children.last?.position)!.x - 10, y:((tileMaster.children.last?.position)!.y + 10))
        }
        
        tileMaster.addChild(tile)
    }
    
    func success() {
        score += 1
        print("score: " + String(score))
        
        (tileMaster.children[currentPosition] as! SKSpriteNode).color = .white
    }
    
    //if tile is missed
    func lose() {
        print("you lose")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            //print(""t)
            move(location: t.location(in: self))
        }
    }
    
}
