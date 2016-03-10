//
//  Hist+CoreDataProperties.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-09.
//  Copyright © 2016 FixCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hist {

    @NSManaged var name: String?
    @NSManaged var dateTriggered: NSDate?

}
