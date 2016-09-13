//
//  Content.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/12/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

@objc(Content)
class Content: NSManagedObject {

    @NSManaged var date_created: NSDate?
    @NSManaged var data: String?
    @NSManaged var type: String?
    @NSManaged var stories: NSSet?

}
