//
//  PictureServiceProtocol.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol PicturesServiceProtocol {
    
    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> Void)
    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}
