//
//  StoryPersistence.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/6/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

class StoryPersistence{
    func save(title : String){
        // create an instance of our managedObjectContext
        let moc = DataPersistence().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Story", inManagedObjectContext: moc) as! Story
        
        // add our data
        entity.title = title
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getAll() -> [Story]{
        let moc = DataPersistence().managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Story")
        
        do {
            return try moc.executeFetchRequest(Fetch) as! [Story]
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}