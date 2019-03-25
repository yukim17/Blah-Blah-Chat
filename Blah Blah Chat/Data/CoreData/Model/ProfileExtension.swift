//
//  ProfileExtension.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 23.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import CoreData

extension Profile {
    
    private static let templateName = "Profile"
    
    static func insertProfile(in context: NSManagedObjectContext) -> Profile? {
        guard let profile = NSEntityDescription.insertNewObject(forEntityName: templateName, into: context) as? Profile else {
            return nil
        }
        return profile
    }
    
    static func fetchRequestProfile(model: NSManagedObjectModel) -> NSFetchRequest<Profile>? {
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Profile> else {
            print("No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    static func findOrInsertProfile(in context: NSManagedObjectContext) -> Profile? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            return nil
        }
        var profile: Profile?
        guard let fetchRequest = Profile.fetchRequestProfile(model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundUser = results.first {
                profile = foundUser
            }
        } catch {
            print("Failed to fetch Profile: \(error)")
        }
        if profile == nil {
            profile = Profile.insertProfile(in: context)
        }
        return profile
    }
    
    func updateFields(with data: ProfileData) {
        if data.nameChanged {
            self.name = data.name
        }
        if data.descriptionChanged {
            self.descr = data.description
        }
        if data.photoChanged {
            self.photo = data.photo?.pngData()
        }
        if data.nameChanged || data.descriptionChanged || data.photoChanged {
            self.timestamp = Date()
        }
    }
}
