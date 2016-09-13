//
//  ContentPersistence.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/6/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import CoreData

class ContentPersistence{
    
    let globalPersistence : DataPersistence = DataPersistence.sharedInstance
    
    func save(){
        let moc = self.globalPersistence.managedObjectContext
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getAll() -> [Content]{
        let moc = self.globalPersistence.managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Content")
        
        do {
            return try moc.executeFetchRequest(Fetch) as! [Content]
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func createEntity() -> Content {
        let moc = self.globalPersistence.managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Content", inManagedObjectContext: moc) as! Content
        
        return entity
    }
}