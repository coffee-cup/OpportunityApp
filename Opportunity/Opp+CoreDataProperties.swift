//
//  Opp+CoreDataProperties.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-27.
//  Copyright © 2016 FixCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Opp {

    @NSManaged var name: String?
    @NSManaged var dateCreated: NSDate?
    @NSManaged var colour: String?
    @NSManaged var disabled: Bool
    
}
