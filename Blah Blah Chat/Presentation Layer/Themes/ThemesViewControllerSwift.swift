//
//  ThemesViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 05.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    private let model: ThemesModelProtocol
    
    init(model: ThemesModelProtocol) {
        self.model = model
        super.init(nibName: "ThemesViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let theme = UserDefaults.standard.colorForKey(key: "Theme") {
                DispatchQueue.main.async {
                    self.view.backgroundColor = theme
                }
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Themes"
        let leftItem = UIBarButtonItem(title: "Back",
                                       style: .plain,
                                       target: self,
                                       action: #selector(closeView))
        navigationItem.setLeftBarButton(leftItem, animated: true)
    }

    @IBAction func selectThemeOne(_ sender: Any) {
        let selectedColor = model.theme1
        model.closure(self, selectedColor)
        self.view.backgroundColor = selectedColor
        //self.reloadView()
    }

    @IBAction func selectThemeTwo(_ sender: Any) {
        let selectedColor = model.theme2
        model.closure(self, selectedColor)
        self.view.backgroundColor = selectedColor
       // self.reloadView()
    }

    @IBAction func selectThemeThree(_ sender: Any) {
        let selectedColor = model.theme3
        model.closure(self, selectedColor)
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

    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}
