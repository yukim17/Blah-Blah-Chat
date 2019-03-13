//
//  DataManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol DataManager {
    func saveProfile(data: ProfileData, completion: @escaping (_ successful:Bool)->())
    func loadProfile(completion: @escaping (_ profile:ProfileData?)->())
}
