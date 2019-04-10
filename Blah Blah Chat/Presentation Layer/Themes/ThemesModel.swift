//
//  ThemesModel.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol ThemesModelProtocol: class {
    var theme1: UIColor { get }
    var theme2: UIColor { get }
    var theme3: UIColor { get }
}

class ThemesModel: ThemesModelProtocol {

    var theme1, theme2, theme3: UIColor

    init(theme1: UIColor, theme2: UIColor, theme3: UIColor) {
        self.theme1 = theme1
        self.theme2 = theme2
        self.theme3 = theme3
    }
}
