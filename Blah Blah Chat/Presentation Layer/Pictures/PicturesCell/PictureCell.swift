//
//  PictureCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell, PictureCellConfigurationProtocol {
    
    var previewUrl, largeImageUrl: String?
    
    @IBOutlet var picImageView: UIImageView!
    
    func setup(image: UIImage, picture: Picture) {
        picImageView.image = image
        previewUrl = picture.previewUrl
        largeImageUrl = picture.largeImageUrl
    }
}
