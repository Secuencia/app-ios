//
//  Story.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/6/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

@objc(Story)
class Story: NSManagedObject {
    
    @NSManaged var brief: String?
    @NSManaged var date_created: NSDate?
    @NSManaged var last_modified: NSDate?
    @NSManaged var title: String?

}
