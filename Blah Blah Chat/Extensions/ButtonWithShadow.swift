//
//  ButtonWithShadow.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 22.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ButtonWithShadow: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
}
