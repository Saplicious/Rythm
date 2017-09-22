//
//  Coin.swift
//  Rhythm
//
//  Created by Jack Jiang on 9/16/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    var coinId = false
    
    func setCoinId(id: Bool){
        self.coinId = id
    }

    func getTileId() -> Bool {
        return self.coinId
    }
    
}
