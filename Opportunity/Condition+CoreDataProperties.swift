//
//  Condition+CoreDataProperties.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-28.
//  Copyright © 2016 FixCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Condition {

    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var ownerOpp: Opp?
    @NSManaged var message: String?
    @NSManaged var newlyCreated: NSNumber?

}
