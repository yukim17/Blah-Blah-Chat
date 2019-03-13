//
//  SaveProfileOperation.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 13.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class SaveProfileOperation: Operation {
    
    var saveSucceeded: Bool = true
    private let profileHandler: ProfileHandler
    private let profile: ProfileData
    
    
    init(profileHandler: ProfileHandler, profile: ProfileData) {
        self.profileHandler = profileHandler
        self.profile = profile
        super.init()
    }
    
    
    override func main() {
        if self.isCancelled { return }
        self.saveSucceeded = self.profileHandler.saveData(profile: self.profile)
    }
    
}
