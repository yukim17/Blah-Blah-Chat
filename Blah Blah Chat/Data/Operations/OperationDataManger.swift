//
//  OperationDataManger.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 09.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class OperationDataManager: DataManager {

    let profileHandler: ProfileHandler = ProfileHandler()

    func saveProfile(data: ProfileData, completion: @escaping (Bool) -> Void) {

        let operationQueue = OperationQueue()
        let saveOperation = SaveProfileOperation(profileHandler: self.profileHandler, profile: data)
        saveOperation.qualityOfService = .userInitiated

        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveOperation.saveSucceeded)
            }
        }
        operationQueue.addOperation(saveOperation)
    }

    func loadProfile(completion: @escaping (ProfileData?) -> Void) {

        let operationQueue = OperationQueue()
        let loadOperation = LoadProfileOperation(profileHandler: self.profileHandler)
        loadOperation.qualityOfService = .userInitiated

        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(loadOperation.profile)
            }
        }
        operationQueue.addOperation(loadOperation)
    }
}
