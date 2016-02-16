//
//  Regional+CoreDataProperties.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 2/15/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Regional {

    @NSManaged var regionalNumber: NSNumber?
    @NSManaged var name: String?
    @NSManaged var teamRegionalPerformances: NSSet?
    @NSManaged var matches: NSSet?

}
