//
//  Background.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-29.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation
import UIKit

// Class to handle all background tasks
class Background {
    
    var store: Store
    
    init() {
        store = Store()
    }
    
    // run background fetch and trigger any opps that can be triggered
    // returns true or false if an opp was triggered
    func backgroundFetch() -> Bool {
        let opps = store.getOpps()
        var oneTriggered = false
        for opp in opps {
            let shouldTrigger = parseOpp(opp)
            if shouldTrigger {
                createTriggerNotification(opp)
                oneTriggered = true
            }
        }
        return oneTriggered
    }
    
    func createTriggerNotification(opp: Opp) {
        // if there is already a notification for this opp, do not make a new one
        if !allowedNotification(opp) {
            return
        }
        
        let notification = UILocalNotification()
        notification.alertBody = opp.name!
        notification.alertAction = "open"
        notification.fireDate = NSDate()
        
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": opp.objectID.URIRepresentation().absoluteString]
        notification.category = opp.colour!
        
        // update last triggered time of opp
        store.setLastTriggered(opp)
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // returns whether or not we are allowed to set notification for opp
    func allowedNotification(opp: Opp) -> Bool {
//        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications == nil ?
//            UIApplication.sharedApplication().scheduledLocalNotifications! : []
//        for noti in notifications {
//            let userInfo = noti.userInfo
//            if userInfo != nil {
//                if let id = userInfo!["id"] as? String {
//                    if id == opp.objectID.URIRepresentation().absoluteString {
//                        return true
//                    }
//                }
//            }
//        }
        if opp.lastTriggered != nil {
            let elapsedTime = NSDate().timeIntervalSinceDate(opp.lastTriggered!)
            if elapsedTime <= 30 * 60 { // 30 minutes
                return false
            }
        }
        return true
    }
    
    func parseOpp(opp: Opp) -> Bool {
        let conditions = store.getConditionsForOpp(opp)
        for cond in conditions {
            if !checkCondition(cond) {
                return false
            }
        }
        return conditions.count != 0
    }
    
    // returns true if condition passes and can trigger opp
    func checkCondition(condition: Condition) -> Bool {
        let type = condition.type!
        if type == TIME_RANGE {
            return checkTimeRange(condition)
        }
        return false
    }
    
    // parses and checks time range condition and returns
    // true if can trigger opp
    func checkTimeRange(condition: Condition) -> Bool {
        let values = ConditionParser.parseTimeRange(condition.value!)
        let lowValue = values.0
        let upValue = values.1
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        // the 24 hour
        let hour24 = Int(formatter.stringFromDate(NSDate()))!
        
        // all day time range, always trigger
        if lowValue == 0 && upValue == 0 {
            return true
        }
        
        if hour24 >= lowValue && hour24 <= upValue {
            return true
        }
        return false
        
    }
}