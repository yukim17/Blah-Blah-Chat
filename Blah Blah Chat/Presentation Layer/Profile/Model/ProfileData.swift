//
//  ProfileData.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 09.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol AppUserData {
    var name: String? { get set }
    var description: String? { get set }
    var picture: UIImage? { get set }
}

protocol AppUserModelProtocol: AppUserData {
    func set(on profile: AppUserData)
    func save(_ completion: @escaping (Bool) -> Void)
    func load(_ completion: @escaping (AppUserData?) -> Void)
}

class Profile: AppUserData {
    
    var name: String?
    var description: String?
    var picture: UIImage?
    
    init(name: String? = nil, descr: String? = nil, picture: UIImage? = nil) {
        self.name = name
        self.description = descr
        self.picture = picture
    }
}

class ProfileModel: AppUserModelProtocol {
    
    private let dataService: DataManager
    
    var name: String?
    var description: String?
    var picture: UIImage?
    
    init(dataService: DataManager, name: String? = nil, descr: String? = nil, picture: UIImage? = nil) {
        self.dataService = dataService
        
        self.name = name
        self.description = descr
        self.picture = picture
    }
    
    func set(on profile: AppUserData) {
        self.name = profile.name
        self.description = profile.description
        self.picture = profile.picture
    }
    
    func save(_ completion: @escaping (Bool) -> Void) {
        dataService.saveAppUser(self, completion: completion)
    }
    
    func load(_ completion: @escaping (AppUserData?) -> Void) {
        dataService.loadAppUser(completion: completion)
    }
    
}
