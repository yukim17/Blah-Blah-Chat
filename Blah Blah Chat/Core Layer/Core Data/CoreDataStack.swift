//
//  CoreDataStack.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 20.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    var storeURL: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("BlahBlahChat.sqlite")
    }

    private let dataModelName = "ProfileModel"
    private let dataModelExtention = "momd"

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtention)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var coreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            print("Error adding persistent store to coordinator: \(error)")
        }
        return coordinator
    }()

    lazy var masterContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    lazy var mainContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.masterContext
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    lazy var saveContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    func performSave(with context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completion(error)
                }
                
                if let parent = context.parent {
                    self?.performSave(with: parent, completion: completion)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
