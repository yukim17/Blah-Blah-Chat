//
//  Picture.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let previewUrl: String
    let largeImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewURL"
        case largeImageUrl = "largeImageURL"
    }
}
