//
//  Opp+CoreDataProperties.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-29.
//  Copyright © 2016 FixCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Opp {

    @NSManaged var colour: String?
    @NSManaged var dateCreated: NSDate?
    @NSManaged var disabled: NSNumber?
    @NSManaged var name: String?
    @NSManaged var conditions: NSSet?
    @NSManaged var lastTriggered: NSDate?
    @NSManaged var read: NSNumber?

}
