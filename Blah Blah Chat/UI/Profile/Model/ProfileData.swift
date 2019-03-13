//
//  ProfileData.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 09.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class ProfileData {
    var name: String?
    var description: String?
    var photo: UIImage?
    
    var nameChanged: Bool = false
    var descriptionChanged: Bool = false
    var photoChanged: Bool = false
    
    init() {}
    
    init(name: String?, descr: String?, image: UIImage?) {
        self.name = name
        self.description = descr
        self.photo = image
    }
    
}
