//
//  ThemesManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol ThemesManagerProtocol {
    func apply(_ theme: UIColor, save: Bool)
    func loadAndApply()
}

class ThemesManager: ThemesManagerProtocol {

    func apply(_ theme: UIColor, save: Bool) {
        DispatchQueue.global(qos: .utility).async {
            if save {
                UserDefaults.standard.setColor(color: theme, forKey: "Theme")
            }
            DispatchQueue.main.async {
                UINavigationBar.appearance().backgroundColor = theme
                UINavigationBar.appearance().barTintColor = theme
                UINavigationBar.appearance().tintColor = UIColor.black
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                let windows = UIApplication.shared.windows as [UIWindow]
                for window in windows {
                    let subviews = window.subviews as [UIView]
                    for vws in subviews {
                        vws.removeFromSuperview()
                        window.addSubview(vws)
                    }
                }
            }
        }
    }

    func loadAndApply() {
        DispatchQueue.global(qos: .userInteractive).async {
            if let theme = UserDefaults.standard.colorForKey(key: "Theme") {
                DispatchQueue.main.async {
                    self.apply(theme, save: false)
                }
            }
        }
    }

}
