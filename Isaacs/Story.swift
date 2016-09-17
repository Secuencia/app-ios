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
    @NSManaged public var contents: NSOrderedSet?
    
    func addContent(newContent : Content){
        self.mutableOrderedSetValueForKey("contents").addObject(newContent)
    }
    
    func swap (contentA : Content, contentB : Content){
        let idx1 : Int = (contents?.indexOfObject(contentA))!
        let idx2 : Int = (contents?.indexOfObject(contentB))!
        self.mutableOrderedSetValueForKey("contents").exchangeObjectAtIndex(idx1, withObjectAtIndex: idx2)
    }
}
