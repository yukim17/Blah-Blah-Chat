//
//  PictureModel.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class PicturesModel: PicturesModelProtocol {
    
    private let picturesService: PicturesServiceProtocol
    var data: [Picture] = []
    
    init(picturesService: PicturesServiceProtocol) {
        self.picturesService = picturesService
    }
    
    func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        picturesService.downloadPicture(urlString: urlString) { image, _ in
            
            guard let image = image else {
                return completionHandler(nil)
            }
            completionHandler(image)
        }
    }
    
    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        picturesService.getPictures { pictures, errorText in
            
            guard let pictures = pictures else {
                completionHandler(nil, errorText)
                return
            }
            
            completionHandler(pictures, nil)
        }
    }
}
