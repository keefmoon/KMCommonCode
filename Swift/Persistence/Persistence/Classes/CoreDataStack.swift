//
//  CoreDataStack.swift
//  KMModulePersistence
//
//  Created by Keith Moon on 30/12/2014.
//  Copyright (c) 2014 Data Ninjitsu. All rights reserved.
//

import Foundation
import CoreData


public class CoreDataStack {
    
    private let modelURL, storeURL : NSURL
    private var existingStoreURL : NSURL?
    private let storeType : String

    public init(modelURL: NSURL, storeURL: NSURL, existingStoreURL: NSURL?, storeType: String) {
        
        self.modelURL = modelURL
        self.storeURL = storeURL
        self.existingStoreURL = existingStoreURL
        self.storeType = storeType

    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dataninjitsu.TaskNinja" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        return NSManagedObjectModel(contentsOfURL: self.modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.storeURL
        let sqlFileAlreadyExists = NSFileManager.defaultManager().fileExistsAtPath(url.path!)
        
        if !sqlFileAlreadyExists {
            if let bundleSQLPath = self.existingStoreURL {
                var copyError: NSError? = nil
                do {
                    try NSFileManager.defaultManager().copyItemAtURL(bundleSQLPath, toURL: self.storeURL)
                } catch var error as NSError {
                    copyError = error
                } catch {
                    fatalError()
                }
                if let checkError = copyError {
                    NSLog("Copy error: \(checkError), \(checkError.userInfo)")
                }
            }
        }
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(self.storeType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var frontendContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        // Respond to DidSave notification and merge
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification,
            object: self.backendContext,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification: NSNotification) -> Void in
            
            managedObjectContext.performBlock({ () -> Void in
                managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            })
        })
        
        return managedObjectContext
    }()
    
    lazy var backendContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.backendContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    // MARK: - Amending Model
    
    public func performDataStoreWork(workBlock: (workContext: NSManagedObjectContext) -> (), completionBlock: () -> ()) {
        
        if let backContext = self.backendContext {
            
            backContext.performBlock({ () -> Void in
                workBlock(workContext: backContext)
                self.saveContext()
                
                if let frontContext = self.frontendContext {
                    frontContext.performBlock({ () -> Void in
                        workBlock(workContext: frontContext)
                    })
                }
            })
        }
    }
    
    // MARK: - Fetching from Model
    
    

}