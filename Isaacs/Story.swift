//
//  Story+CoreDataClass.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/14/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

@objc(Story)
public class Story: NSManagedObject {
    
    @NSManaged public var brief: String?
    @NSManaged public var date_created: NSDate?
    @NSManaged public var last_modified: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var contents: NSSet?

}
