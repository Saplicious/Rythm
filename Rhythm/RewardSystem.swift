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
    var hasRewardBeenClaimed = false
    
    //reward player every day
    
    public func rewardPlayer() {
        
    }
    
    public func getLastLogonDate() -> Date {
        return lastLogonDate
    }
    
    public func setLastLogonDate(date: Date) {
        lastLogonDate = date
    }
    
    public func getDate() -> Date {
        currentDateTime = Date()
        return currentDateTime
        
    }
    
}
