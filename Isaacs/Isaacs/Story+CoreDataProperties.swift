//
//  Story+CoreDataProperties.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/12/16.
//  Copyright © 2016 Inspect. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Story {

    @NSManaged var brief: String?
    @NSManaged var date_created: NSDate?
    @NSManaged var last_modified: NSDate?
    @NSManaged var title: String?
    @NSManaged var contents: NSSet?

}
