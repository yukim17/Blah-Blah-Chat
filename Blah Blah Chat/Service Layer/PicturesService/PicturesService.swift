//
//  PicturesService.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class PicturesService: PicturesServiceProtocol {
    
    private let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        
        let requestConfig = RequestsFactory.PixabayRequests.downloadImage(urlString: urlString)
        
        requestSender.send(config: requestConfig) { (result: Result<UIImage>) in
            
            switch result {
            case .success(let picture):
                completionHandler(picture, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        
        let requestConfig = RequestsFactory.PixabayRequests.searchImages()
        
        requestSender.send(config: requestConfig) { (result: Result<[Picture]>) in
            switch result {
            case .success(let pictures):
                completionHandler(pictures, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
}
