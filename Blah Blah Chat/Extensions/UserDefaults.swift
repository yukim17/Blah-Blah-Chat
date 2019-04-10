//
//  UserDefaults.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 06.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

extension UserDefaults {

    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }

    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }

}
