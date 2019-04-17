//
//  PictureProtocols.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol CollectionPickerControllerProtocol: class {
    func close()
}

protocol PicturesViewControllerDelegateProtocol: class {
    func collectionPickerController(_ picker: CollectionPickerControllerProtocol, didFinishPickingImage image: UIImage)
}

protocol PictureCellConfigurationProtocol {
    var previewUrl: String? { get set }
    var largeImageUrl: String? { get set }
}

protocol PicturesModelProtocol: class {
    
    var data: [Picture] { get set }
    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> Void)
    func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> Void)
}
