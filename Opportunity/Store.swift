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
    
    func getOpps() -> [Opp] {
        return dataContext.opps.toArray()
    }
    
    func createOpp(name: String, colour: UIColor) {
        let opp = dataContext.opps.createEntity()
        opp.name = name
        opp.colour = colour.toHexString()
        opp.dateCreated = NSDate()
        opp.disabled = false
        save()
    }
    
    func toggleDisabled(opp: Opp) {
        opp.disabled = false
        save()
    }
    
    func deleteOpp(opp: Opp) {
        dataContext.opps.deleteEntity(opp)
        save()
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
