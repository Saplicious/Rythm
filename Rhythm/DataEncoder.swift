//
//  DataEncoder.swift
//  Rhythm
//
//  Created by Jack Jiang on 9/18/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation
import os.log

class DataEncoder: NSObject, NSCoding {
    
    var lastLogonDate: Date?
    var highScore: Int
    var currency: Int
    
    init(lastLogonDate: Date?, highScore: Int, currency: Int) {
        self.lastLogonDate = lastLogonDate
        self.highScore = highScore
        self.currency = currency
    }
    
    //set highscore
    func setHighScore(hs: Int) {
        self.highScore = hs
    }
    
    //set lastLogonDate
    func setLastLogonDate(lld: Date) {
        self.lastLogonDate = lld
    }
    
    //set highscore
    func getHighScore() -> Int {
        return self.highScore
    }
    //set currency
    func setCurrency(c: Int) {
        self.currency = c
    }
    
    //set lastLogonDate
    func getLastLogonDate() -> Date? {
        return self.lastLogonDate
    }

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("gamedata")
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let lastLogonDate = aDecoder.decodeObject(forKey: "lastLogonDate") as? Date
        let highScore = aDecoder.decodeInteger(forKey: "highScore")
        let currency = aDecoder.decodeInteger(forKey: "currency")
        
        print(highScore)
        
        self.init(lastLogonDate: lastLogonDate, highScore: highScore, currency: currency)
    }
    
    func encode(with aCoder: NSCoder) {
        print("encoding: " + String(highScore))
        aCoder.encode(lastLogonDate, forKey: "lastLogonDate")
        aCoder.encode(highScore, forKey: "highScore")
        aCoder.encode(currency, forKey: "currency")
    }
    
    
}
