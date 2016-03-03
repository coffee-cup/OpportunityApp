//
//  Store.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-27.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AlecrimCoreData

extension DataContext {
    var opps:      Table<Opp>     { return Table<Opp>(dataContext: self) }
    var conditions:      Table<Condition>     { return Table<Condition>(dataContext: self) }
}

class Store {
    let appDelegate: AppDelegate!
    
    lazy var dataContext: DataContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let modelURL = appDelegate.managedObjectURL
        return try! DataContext(dataContextOptions: DataContextOptions(managedObjectModelURL: modelURL))
    }()
    
    static let sharedInstance = Store()
    
    init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func getOpps(sortDesc: String = "Name") -> [Opp] {
        if sortDesc == "Colour" {
            return dataContext.opps.sort {$0.colour < $1.colour}
        } else if sortDesc == "Name" {
            return dataContext.opps.sort {$0.name < $1.name}
        } else if sortDesc == "Disabled" {
            return dataContext.opps.sort {$0.disabled!.integerValue < $1.disabled!.integerValue}
        }
        return dataContext.opps.toArray()
    }
    
    func setOppValues(opp: Opp, name: String, colour: UIColor, conditions: [Condition]) {
        opp.name = name
        opp.colour = colour.toHexString()
//        opp.conditions = conditions
    }
    
    func createOpp(name: String, colour: UIColor, conditions: [Condition]) -> Opp {
        let opp = dataContext.opps.createEntity()
        setOppValues(opp, name: name, colour: colour, conditions: conditions)
        opp.dateCreated = NSDate()
        opp.disabled = 0
        opp.read = 1
        save()
        return opp
    }
    
    // toggle disable property of opp
    func toggleDisabled(opp: Opp) {
        opp.disabled = opp.disabled! == 1 ? 0 : 1
        save()
    }
    
    // set last triggered time of opp to now
    func setLastTriggered(opp: Opp) {
        opp.lastTriggered = NSDate()
        save()
    }
    
    func deleteOpp(opp: Opp) {
        // delete all conditions belonging to opp to
//        if opp.conditions != nil {
//            for c in opp.conditions! {
//                opp.removeConditionObject(c as! Condition)
//                deleteCondition(c as! Condition)
//            }
//        }
        let oppConditions = getConditionsForOpp(opp)
        for c in oppConditions {
            deleteCondition(c)
        }
        dataContext.opps.deleteEntity(opp)
        save()
    }
    
    func setOppRead(opp: Opp) {
        opp.read = 1
        save()
    }
    
    func markOppsRead() {
        for opp in getOpps() {
            opp.read = 1
        }
        save()
    }
    
    func deleteCondition(condition: Condition) {
        dataContext.conditions.deleteEntity(condition)
        save()
    }
    
    func getConditionsForOpp(opp: Opp) -> [Condition] {
        let conditions = dataContext.conditions.filter{$0.ownerOpp == opp}
        return conditions
    }
    
    func createCondition(forOpp: Opp, type: String, value: String, message: String) {
        let condition = dataContext.conditions.createEntity()
        setConditionValues(condition, opp: forOpp, type: type, value: value, message: message)
        condition.newlyCreated = true
        if forOpp.conditions == nil {
            forOpp.conditions = NSSet(object: condition)
        } else {
            forOpp.addConditionObject(condition)
        }
        save()
    }
    
    func fullSetConditionsForOpp(forOpp: Opp) {
        let conditions = getConditionsForOpp(forOpp)
        for c in conditions {
            c.newlyCreated = false
        }
        save()
    }
    
    func updateCondition(condition: Condition, ownerOpp: Opp, type: String, value: String, message: String) {
        setConditionValues(condition, opp: ownerOpp, type: type, value: value, message: message)
        save()
    }
    
    func setConditionValues(condition: Condition, opp: Opp, type: String, value: String, message: String) {
        condition.ownerOpp = opp
        condition.type = type
        condition.value = value
        condition.message = message
    }
    
    func save() {
        do {
            try dataContext.save()
        }
        catch let error {
            // do a nice error handling here
            print(error)
        }
    }
}
