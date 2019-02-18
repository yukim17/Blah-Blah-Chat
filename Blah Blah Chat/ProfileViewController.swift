//
//  ProfileViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
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
        
        imagePicker.delegate = self
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
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profilePhotoImageView.contentMode = .scaleAspectFit
        self.profilePhotoImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func pickPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
        let alert = UIAlertController(title: nil, message: "Выбери изображение профиля", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default) { (result : UIAlertAction) -> Void in
            self.pickPhotoFromCamera()
        })
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default) { (result : UIAlertAction) -> Void in
            self.pickPhotoFromLibrary()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickPhotoFromLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhotoFromCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker,animated: true,completion: nil)
    }
    
}

