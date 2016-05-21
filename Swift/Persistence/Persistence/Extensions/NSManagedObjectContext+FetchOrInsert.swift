//
//  NSManagedObjectContext+FetchOrInsert.swift
//  KMModulePersistence
//
//  Created by Keith Moon on 02/01/2015.
//  Copyright (c) 2015 Data Ninjitsu. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    public func resultsFromFetchRequest(request: NSFetchRequest) -> Array<AnyObject>? {
        
        var fetchError : NSError?
        var results: [AnyObject]?
        do {
            results = try self.executeFetchRequest(request)
        } catch let error as NSError {
            fetchError = error
            results = nil
        }
        
        if let error = fetchError {
            NSLog("Fetching Error: \(error.description)")
        }
        
        return results
    }
}