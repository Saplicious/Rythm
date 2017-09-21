//
//  Tile.swift
//  Rhythm
//
//  Created by Jack Jiang on 9/16/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKSpriteNode {
    
    var tileId: Int = 0
    
    func setTileId(id: Int){
        self.tileId = id
    }
    
    func getTileId() -> Int {
        return self.tileId
    }
    
}
