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
    
    let globalPersistence : DataPersistence = DataPersistence.sharedInstance
    
    func save(){
        let moc = self.globalPersistence.managedObjectContext
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getAll() -> [Story]{
        let moc = self.globalPersistence.managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Story")
        
        do {
            return try moc.executeFetchRequest(Fetch) as! [Story]
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func deleteEntity(content:Story){
        let moc = self.globalPersistence.managedObjectContext
        moc.deleteObject(content)
    }
    
    func createEntity() -> Story {
        let moc = self.globalPersistence.managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Story", inManagedObjectContext: moc) as! Story
        
        return entity
    }
}
