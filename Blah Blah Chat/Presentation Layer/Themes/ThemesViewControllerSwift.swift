//
//  ThemesViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 05.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {

    var model = ThemesModel(theme1: #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1), theme2: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1), theme3: #colorLiteral(red: 0.8588235294, green: 0.9176470588, blue: 1, alpha: 1))
    var closure: ((_ selectedColor: UIColor) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectThemeOne(_ sender: Any) {
        let selectedColor = model.theme1
        if let closure = closure {
            closure(selectedColor)
        }
        self.view.backgroundColor = selectedColor
        //self.reloadView()
    }

    @IBAction func selectThemeTwo(_ sender: Any) {
        let selectedColor = model.theme2
        if let closure = closure {
            closure(selectedColor)
        }
        self.view.backgroundColor = selectedColor
       // self.reloadView()
    }

    @IBAction func selectThemeThree(_ sender: Any) {
        let selectedColor = model.theme3
        if let closure = closure {
            closure(selectedColor)
        }
        self.view.backgroundColor = selectedColor
        //self.reloadView()
    }

//    private func reloadView() {
//        for window in UIApplication.shared.windows {
//            for view in window.subviews {
//                view.removeFromSuperview()
//                window.addSubview(view)
//            }
//        }
//    }

    @IBAction func closeView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
