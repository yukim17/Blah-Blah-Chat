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
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var desciptionTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var dataWasChanged: Bool {
        get{
            return model.name != nameTextField.text || model.description != desciptionTextField.text || model.picture != profilePhotoImageView.image
        }
    }
    
    private var editingMode: Bool = false
    private var model: AppUserModelProtocol
    
    init(model: AppUserModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupSubviews()

        self.imagePicker.delegate = self
        self.desciptionTextField.delegate = self
        self.nameTextField.delegate = self
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        self.nameTextField.autocorrectionType = UITextAutocorrectionType.no
        self.desciptionTextField.autocorrectionType = UITextAutocorrectionType.no

        model.load { [unowned self] profile in
            guard let profile = profile else {
                self.activityIndicator.stopAnimating()
                return
            }
            self.model.set(on: profile)
            if let name = profile.name {
                self.nameTextField.text = name
            }
            if let descr = profile.description {
                self.desciptionTextField.text = descr
            }
            if let picture = profile.picture {
                self.profilePhotoImageView.image = picture
            }
            self.activityIndicator.stopAnimating()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = self.pickPhotoButton.frame.width/2
        self.pickPhotoButton.layer.cornerRadius = cornerRadius
        self.profilePhotoImageView.layer.cornerRadius = cornerRadius
    }
    
    private func setupSubviews() {
        self.navigationItem.title = "Profile"
        self.editButton.layer.borderWidth = 1.0
        self.editButton.layer.borderColor = UIColor.black.cgColor
        self.editButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = 1.0
        self.saveButton.layer.borderColor = UIColor.black.cgColor
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.isHidden = true
        self.pickPhotoButton.layer.masksToBounds = true
        self.profilePhotoImageView.layer.masksToBounds = true
        self.activityIndicator.center = self.view.center
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(backToChats))
        setEnabledState(enabled: dataWasChanged)
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.editingMode = true
        self.setEnabledState(enabled: false)
        self.setEditingState(editing: true)
    }

    @objc func backToChats() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pickPhoto(_ sender: Any) {
        print("Выбери изображение профиля")

        if !self.editingMode {
            self.showAlert(title: "Нажмите кнопку Редактировать", message: "Чтобы выбрать фото, нажмите кнопку Редактировать", retry: nil)
            return
        }
        let alert = UIAlertController(title: nil, message: "Выбери изображение профиля", preferredStyle: UIAlertController.Style.actionSheet)

        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default) { (_: UIAlertAction) -> Void in
            self.pickPhotoFromCamera()
        })
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default) { (_: UIAlertAction) -> Void in
            self.pickPhotoFromLibrary()
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        view.endEditing(true)
        
        if nameTextField.text != model.name {
            model.name = nameTextField.text
        }
        
        if desciptionTextField.text != model.description {
            model.description = desciptionTextField.text
        }
        
        if profilePhotoImageView.image != model.picture {
            model.picture = profilePhotoImageView.image
        }
        
        model.save() { [weak self] error in
            if !error {
                self?.showSuccessAlert()
            } else {
                self?.showErrorAlert()
            }
            
            self?.activityIndicator.stopAnimating()
        }
        self.editingMode = false
        self.setEditingState(editing: false)
        self.setEnabledState(enabled: false)
    }
    
    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Changes saved!", message: nil, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "could not save data", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default) { action in
            self.saveButtonPressed(self);
        })
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Change ViewController State

extension ProfileViewController {

    private func setEditingState(editing: Bool) {
        if editing {
            self.nameTextField.placeholder = "Введите имя"
        }

        self.editButton.isHidden = editing
        self.saveButton.isHidden = !editing

        self.nameTextField.isEnabled = editing
        self.desciptionTextField.isEnabled = editing
    }

    private func setEnabledState(enabled: Bool) {
        self.saveButton.isEnabled = enabled
    }

}

// MARK: - Hide Keyboard

extension ProfileViewController {

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight
            print("keyboard height is:", keyboardHeight)
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hides keyboard when tapped outside keyboard
        self.view.endEditing(true)
    }

}

// MARK: - Photo picker methods

extension ProfileViewController {

    func pickPhotoFromLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }

    func pickPhotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            showNoCameraWarn()
        }
    }

    func showNoCameraWarn() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, your device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

}

// MARK: - Image Picker Delegate Methods

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profilePhotoImageView.image = image
            setEnabledState(enabled: dataWasChanged)
        } else {
            // error occured
            print("Error picking image")
        }
        picker.dismiss(animated: true, completion: nil)
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
    
    // user edited text field
    @objc func textFieldDidChange(_ textField: UITextField) {
        setEnabledState(enabled: dataWasChanged)
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 100
    }

}
