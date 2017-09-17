//
//  RewardSystem.swift
//  Rhythm
//
//  Created by Jack Jiang on 9/16/17.
//  Copyright © 2017 William Wong. All rights reserved.
//

import Foundation

class RewardSystem {
    
    public static let sharedInstance:RewardSystem = RewardSystem()
    
    var currentDateTime:Date = Date()
    
    var lastLogonDate = Date()
    
    //reward player every day
    
    //get date
    public func getDate() -> Date {
        currentDateTime = Date()
        return currentDateTime
        
    }
    
    //store date
    public func storeDate() {
        currentDateTime = Date()
        print(currentDateTime)
    }
    
    
}
