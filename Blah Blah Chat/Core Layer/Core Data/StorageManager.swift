//
//  StorageManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 23.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class StorageManager: DataManager {

    private var coreData = CoreDataStack.shared

    func saveProfile(data: ProfileData, completion: @escaping (Bool) -> Void) {
        coreData.saveContext.perform {
            guard let profile = Profile.findOrInsertProfile(in: self.coreData.saveContext) else {
                completion(false)
                return
            }
            profile.updateFields(with: data)
            self.coreData.performSave(with: self.coreData.saveContext) {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }

    func loadProfile(completion: @escaping (ProfileData?) -> Void) {
        let data: ProfileData = ProfileData()
        self.coreData.mainContext.perform {
            guard let profile = Profile.findOrInsertProfile(in: self.coreData.mainContext) else {
                completion(nil)
                return
            }
            data.name = profile.name
            data.description = profile.descr
            if let image = profile.photo {
                data.photo = UIImage(data: image)
            }
            completion(data)
        }
    }
}
