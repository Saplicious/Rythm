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
    
    init(lastLogonDate: Date?, highScore: Int) {
        self.lastLogonDate = lastLogonDate
        self.highScore = highScore
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
    
    //set lastLogonDate
    func getLastLogonDate() -> Date? {
        return self.lastLogonDate
    }

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("gamedata")
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let lastLogonDate = aDecoder.decodeObject(forKey: "lastLogonDate") as? Date
        let highScore = aDecoder.decodeInteger(forKey: "highScore")
        
        print(highScore)
        
        self.init(lastLogonDate: lastLogonDate, highScore: highScore)
    }
    
    func encode(with aCoder: NSCoder) {
        print("encoding: " + String(highScore))
        aCoder.encode(lastLogonDate, forKey: "lastLogonDate")
        aCoder.encode(highScore, forKey: "highScore")
    }
    
    
}
