//
//  ProfileViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var pickPhotoButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // В этом месте выделяются ресурсы под ViewController. В момент вызова метода view на Controller'e еще не существует, тем более элементов, которые располагаются на этой view. Поэтому вместо editButton обнаруживается nil.
        //print(self.editButton.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editButton.layer.borderWidth = 1.0
        self.editButton.layer.borderColor = UIColor.black.cgColor;
        self.editButton.layer.cornerRadius = 10
        self.pickPhotoButton.layer.masksToBounds = true
        self.profilePhotoImageView.layer.masksToBounds = true
        print(self.editButton.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Метод вызывается уже после того, как все элементы появились на экране и для всех элементов рассчитаны размеры и расположение на экране, поэтому значение frame отличается от того что было выведено в viewDidLoad. В методе viewDidLoad view и все subviews загружены в память со значениями из Storyboard
        print(self.editButton.frame)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = self.pickPhotoButton.frame.width/2
        self.pickPhotoButton.layer.cornerRadius = cornerRadius
        self.profilePhotoImageView.layer.cornerRadius = cornerRadius
    }

    @IBAction func pickPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
    }
    
}

