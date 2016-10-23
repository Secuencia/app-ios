//
//  Content+CoreDataClass.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/14/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

@objc(Content)
public class Content: NSManagedObject {
    
    enum types:String{
        case Audio = "Audio"
        case Contact = "Contacto"
        case Text = "Texto"
        case Picture = "Imágen"
    }
    
    @NSManaged public var data: String?
    @NSManaged public var date_created: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var stories: NSSet?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var latitude: NSNumber?

    
}
