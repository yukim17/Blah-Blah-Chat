//
//  ProfileViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet var gcdSaveButton: UIButton!
    @IBOutlet var operationSaveButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var desciptionTextField: UITextField!
    
    var editingMode: Bool = false {
        didSet {
            self.setEditingState(editing: editingMode)
        }
    }
    
    private var profile : ProfileData?
    var dataManager: DataManager? = GCDDataManager()
    
    private var saveChanges: ( () -> Void )?
    
    private var dataWasChanged: Bool {
        get{
            return self.profile?.nameChanged ?? false || self.profile?.descriptionChanged ?? false || self.profile?.photoChanged ?? false
        }
    }
    
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
        self.gcdSaveButton.layer.borderWidth = 1.0
        self.gcdSaveButton.layer.borderColor = UIColor.black.cgColor;
        self.gcdSaveButton.layer.cornerRadius = 10
        self.operationSaveButton.layer.borderWidth = 1.0
        self.operationSaveButton.layer.borderColor = UIColor.black.cgColor;
        self.operationSaveButton.layer.cornerRadius = 10
        self.pickPhotoButton.layer.masksToBounds = true
        self.profilePhotoImageView.layer.masksToBounds = true
        
        imagePicker.delegate = self
        print(self.editButton.frame)
        
        self.editingMode = false
        self.loadFromFile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // adding keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // removing keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 66
            print("keyboard height is:" , keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 64
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hides keyboard when tapped outside keyboard
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = self.pickPhotoButton.frame.width/2
        self.pickPhotoButton.layer.cornerRadius = cornerRadius
        self.profilePhotoImageView.layer.cornerRadius = cornerRadius
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.editingMode = true
        self.setEnabledState(enabled: false)
    }
    
    @IBAction func backToChats(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
        
        if !self.editingMode {
            self.showAlert(title: "Нажмите кнопку Редактировать", message: "Чтобы выбрать фото, нажмите кнопку Редактировать", retry: nil)
            return
        }
        let alert = UIAlertController(title: nil, message: "Выбери изображение профиля", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default) { (result : UIAlertAction) -> Void in
            self.pickPhotoFromCamera()
        })
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default) { (result : UIAlertAction) -> Void in
            self.pickPhotoFromLibrary()
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
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
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            showNoCameraWarn()
        }
    }
    
    func showNoCameraWarn() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, your device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func loadFromFile() {
        self.dataManager?.loadProfile(completion: { (profile) in
            if let unwrappedProfile = profile {
                self.profile = unwrappedProfile
            }
            
            self.profilePhotoImageView.image = profile?.photo ?? UIImage.init(named: "placeholder-user")
            self.nameTextField.text = profile?.name ?? "Введите имя"
            self.desciptionTextField.text = profile?.description ?? "Расскажите о себе"
            
            self.profile = ProfileData(name: self.nameTextField.text, descr: self.desciptionTextField.text, image: self.profilePhotoImageView.image)
        })
    
    }
    
    @IBAction func saveButtonsPressed(_ sender: UIButton) {
        self.nameTextField.resignFirstResponder()
        self.desciptionTextField.resignFirstResponder()
        
        self.saveChanges = {
            
            //self.activityIndicator.startAnimating()
            self.setEnabledState(enabled: false)
            
            self.profile?.name = self.nameTextField.text
            self.profile?.description = self.desciptionTextField.text
            self.profile?.photo = self.profilePhotoImageView.image
            
            let titleOfButton = sender.titleLabel?.text
            
            if titleOfButton == "Operation Save" {
                self.dataManager = OperationDataManager()
            } else {
                self.dataManager = GCDDataManager()
            }
            
            
            self.dataManager?.saveProfile(data: self.profile!, completion: { (saveSucceeded : Bool) in
                
                //self.activityIndicator.stopAnimating()
                
                if saveSucceeded {
                    self.showAlert(title: "Данные сохранены", message: "", retry: nil)
                    self.loadFromFile()
                } else {
                    self.showAlert(title: "Ошибка", message: "Не удалось сохранить данные", retry: nil)
                }
                
                self.setEnabledState(enabled: true)
                self.editingMode = !saveSucceeded
            })
        }
        
        self.saveChanges?();
    }
    
    @IBAction func usernameChangedByEditing(_ sender: UITextField) {
        if let newName = sender.text {
            self.profile?.nameChanged = (newName != (self.profile?.name ?? ""))
            self.setEnabledState(enabled: self.dataWasChanged)
        }
    }
    
    @IBAction func descrChangedByEditing(_ sender: UITextField) {
        if let newDescr = sender.text {
            self.profile?.descriptionChanged = (newDescr != (self.profile?.description ?? ""))
            self.setEnabledState(enabled: self.dataWasChanged)
        }
    }
    
    private func setEditingState(editing: Bool) {
        if (editing) {
            self.nameTextField.placeholder = "Введите имя"
        }
        
        self.editButton.isHidden = editing
        self.gcdSaveButton.isHidden = !editing
        self.operationSaveButton.isHidden = !editing
        
        self.nameTextField.isEnabled = editing
        self.desciptionTextField.isEnabled = editing
    }
    
    
    private func setEnabledState(enabled: Bool) {
        self.gcdSaveButton.isEnabled = enabled
        self.operationSaveButton.isEnabled = enabled
    }
    
}

// MARK: - Image Picker Delegate Methods

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profilePhotoImageView.image = image
            self.profilePhotoImageView.contentMode = .scaleAspectFit
            
            if let savedImage = self.profile?.photo {
                let newImage = image.pngData()!
                let oldImage = savedImage.pngData()!
                self.profile?.photoChanged = !newImage.elementsEqual(oldImage)
            } else {
                self.profile?.photoChanged = true
            }
            
            self.setEnabledState(enabled: self.dataWasChanged)
        } else {
            print("Error picking image")
        }
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 100
    }
    
}

