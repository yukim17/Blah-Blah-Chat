//
//  CoreDataStack.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 20.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import CoreData

typealias SaveCompletion = () -> Void

class CoredataStack {
    
    var storeURL: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    
    let dataModelName = "ProfileModel"
    let dataModelExtention = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtention)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var coreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            print(error)
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
    
    func performSave(with context: NSManagedObjectContext, completion: SaveCompletion? = nil) {
        guard context.hasChanges else {
            completion?()
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
//    func saveProfile(data: ProfileData, completion: @escaping (Bool) -> ()) {
//        self.masterContet.perform {
//            do {
//                guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: self.masterContet) as? Profile else {return}
//                appUser.name = data.name
//                appUser.timestamp = Date()
//                try self.masterContet.save()
//                completion(true)
//            } catch {
//                print(error)
//                completion(false)
//            }
//        }
//    }
//
//    func loadProfile(completion: @escaping (ProfileData?) -> ()) {
//        var appUser: Profile?
//        var profile: ProfileData?
//        guard let fetchRequest = Profile.fetchRequestAppUser(model: self.coreCoordinator.managedObjectModel) else {
//            completion(nil)
//            return
//        }
//        do {
//            let results = try self.masterContet.fetch(fetchRequest)
//            if let foundUser = results.first {
//                appUser = foundUser
//            }
//
//        } catch {
//            print(error)
//        }
//        profile = ProfileData(name: appUser?.name, descr: "", image: nil)
//        completion(profile)
//    }
//
}
