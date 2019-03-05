//
//  ThemesViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 05.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    var model: Themes = Themes(colorOne: #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1), colorTwo: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1), colorThree: #colorLiteral(red: 0.8588235294, green: 0.9176470588, blue: 1, alpha: 1))
    var closure: ((_ selectedColor: UIColor) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectThemeOne(_ sender: Any) {
        let selectedColor = model.theme1
        if let closure = closure {
            closure(selectedColor!)
        }
        self.view.backgroundColor = selectedColor
    }
    
    @IBAction func selectThemeTwo(_ sender: Any) {
        let selectedColor = model.theme2
        if let closure = closure {
            closure(selectedColor!)
        }
        self.view.backgroundColor = selectedColor
        UINavigationBar.appearance().tintColor = selectedColor
    }
    
    @IBAction func selectThemeThree(_ sender: Any) {
        let selectedColor = model.theme3
        if let closure = closure {
            closure(selectedColor!)
        }
        self.view.backgroundColor = selectedColor
        UINavigationBar.appearance().tintColor = selectedColor
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
