//
//  ProfileHandler.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 13.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class ProfileHandler {
    
    private let nameFileName = "name.txt"
    private let descrFileName = "description.txt"
    private let photoFileName = "photo.png"
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveData(profile: ProfileData) -> Bool {
        do {
            if profile.nameChanged, let name = profile.name {
                try name.write(to: filePath.appendingPathComponent(self.nameFileName), atomically: true, encoding: String.Encoding.utf8)
            }
            
            if profile.descriptionChanged, let descr = profile.description {
                try descr.write(to: filePath.appendingPathComponent(self.descrFileName), atomically: true, encoding: String.Encoding.utf8)
            }
            
            if profile.photoChanged, let photo = profile.photo {
                let imageData = photo.pngData();
                try imageData?.write(to: filePath.appendingPathComponent(self.photoFileName), options: .atomic);
            }
            return true
        } catch {
            return false
        }
    }
    
    
    func loadData() -> ProfileData? {
        let profile = ProfileData()
        do {
            profile.name = try String(contentsOf: filePath.appendingPathComponent(self.nameFileName))
            profile.description = try String(contentsOf: filePath.appendingPathComponent(self.descrFileName))
            profile.photo = UIImage(contentsOfFile: filePath.appendingPathComponent(self.photoFileName).path)
            return profile
        } catch {
            return nil
        }
    }
    
}
