//
//  GCDDataManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 09.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {
    
    let profileHandler: ProfileHandler = ProfileHandler()
    
    
    func saveProfile(data: ProfileData, completion: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let saveSucceeded = self.profileHandler.saveData(profile: data)
            
            DispatchQueue.main.async {
                completion(saveSucceeded)
            }
        }
    }
    
    
    func loadProfile(completion: @escaping (_ profile: ProfileData?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let profile = self.profileHandler.loadData()
            
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
}
