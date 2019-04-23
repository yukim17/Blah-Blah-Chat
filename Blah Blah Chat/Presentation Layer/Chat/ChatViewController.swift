//
//  ChatViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 24.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

extension UITableView: DataSourceDelegate {
    // UITableView used as a DataSourceDelegate protocol object
}

class ChatViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var messagesTableView: UITableView! {
        didSet {
            // workaround for displaying messages bottom -> top
            messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    private var titleLabel: UILabel!
    
    private var model: ChatModel
    var sendButtonLocked = false
    
    init(model: ChatModel) {
        self.model = model
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationTitle()
        self.messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.setupTableView()
        self.model.dataSource = MessagesDataSource(delegate: messagesTableView, fetchRequest: model.frService.messagesInConversation(with: model.conversation.conversationId!)!, context: model.frService.saveContext)
        
        if let count = model.conversation.messages?.count, count > 0 {
            messagesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
            setupNoMessagesView()
        }
    }
    
    private func setupNavigationTitle() {
        navigationItem.titleView = titleLabel
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.text = model.conversation.user?.name
    }
    
    private func setupTableView() {
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        
        let nib = UINib(nibName: "IncomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "incomingMessage")
        
        let nib1 = UINib(nibName: "OutcomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib1, forCellReuseIdentifier: "outcomingMessage")
        
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 50
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.messagesTableView.addGestureRecognizer(tapGesture)
    }

    func setupNoMessagesView() {
        let noMessagesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        noMessagesLabel.text = "No messages yet"
        noMessagesLabel.textColor = UIColor.darkGray
        noMessagesLabel.font = UIFont.systemFont(ofSize: 14)
        noMessagesLabel.textAlignment = .center
        self.messagesTableView.tableHeaderView = noMessagesLabel
        self.messagesTableView.tableHeaderView?.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.setUserConnectionTracker(self)
        if model.conversation.isOnline == false {
            changeControlsState(enabled: false)
        } else {
            performAnimationSetLabelState(titleLabel, enabled: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // removing observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        model.makeRead()
        view.gestureRecognizers?.removeAll()
    }

    // MARK: - sendButtonLock
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == messageTextField {
            if let text = messageTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                if sendButtonLocked == true {
                    sendButtonLocked = false
                    performAnimationSetButtonState(sendButton, enabled: true)
                }
            } else {
                if sendButtonLocked == false {
                    sendButtonLocked = true
                    performAnimationSetButtonState(sendButton, enabled: false)
                }
            }
        }
    }

    @IBAction func sendTapped(_ sender: Any) {
        if !sendButtonLocked {
            guard let text = messageTextField.text,
                let receiver = model.conversation.user?.userId, !text.isEmpty else { return }
            model.communicationService.communicator.sendMessage(text: text, to: receiver) { [weak self] success, error in
                if success {
                    self?.messageTextField.text = nil
                    if sendButtonLocked == false {
                        self?.sendButtonLocked = true
                        performAnimationSetButtonState(sendButton, enabled: false)
                    }
                    self?.messagesTableView.tableHeaderView = nil
                } else {
                    let alert = UIAlertController(title: "Error occured", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "done", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = model.dataSource?.fetchedResultsController.sections?.count else {
            return 0
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = model.dataSource?.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageTableViewCell?
        if let message = model.dataSource?.fetchedResultsController.object(at: indexPath) {
            var identifier: String
            if message.isIncoming {
                identifier = "incomingMessage"
            } else {
                identifier = "outcomingMessage"
            }
            
            if let messCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageTableViewCell {
                cell = messCell
            } else {
                cell = MessageTableViewCell(style: .default, reuseIdentifier: identifier)
            }
            
            cell?.configureCell(message: message)
            
            // workaround for displaying messages bottom -> top
            cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    
    // hide the keyboard after pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // limiting input length for textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 300
    }
}

// MARK: - Show/hide Keyboard

extension ChatViewController {

    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.messageTextField.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y >= 0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.view.frame.origin.y -= keyboardRectangle.height
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y < 0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.view.frame.origin.y += keyboardRectangle.height
            }
        }
    }
}

// MARK: - Enable/disable controls
extension ChatViewController: UserConnectionTrackerProtocol {
    
    func changeControlsState(enabled: Bool) {
        if enabled {
            // set controls on
            DispatchQueue.main.async {
                self.textFieldDidChange(self.messageTextField)
                self.messageTextField.isEnabled = true
                self.performAnimationSetLabelState(self.titleLabel, enabled: true)
            }
        } else {
            // set controls off
            DispatchQueue.main.async {
                self.messageTextField.isEnabled = false
                self.performAnimationSetLabelState(self.titleLabel, enabled: false)
                if self.sendButtonLocked == false {
                    self.sendButtonLocked = true
                    self.performAnimationSetButtonState(self.sendButton, enabled: false)
                }
            }
        }
    }
}

// MARK: - Animations
extension ChatViewController {
    
    private func performAnimationSetButtonState(_ button: UIButton, enabled: Bool) {
        if enabled {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                button.setTitleColor(UIColor.green, for: .normal)
            })
            UIView.animate(withDuration: 0.5,
                           animations: {
                            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                button.transform = CGAffineTransform.identity
                            }
            })
        } else {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                button.setTitleColor(UIColor.red, for: .normal)
            })
            UIView.animate(withDuration: 0.5,
                           animations: {
                            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                button.transform = CGAffineTransform.identity
                            }
            })
        }
    }
    
    private func performAnimationSetLabelState(_ label: UILabel, enabled: Bool) {
        
        if enabled {
            // user is online
            UIView.animate(withDuration: 1, animations: { () -> Void in
                label.textColor = UIColor.green
                label.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            })
        } else {
            // user is offline
            UIView.animate(withDuration: 1, animations: { () -> Void in
                label.textColor = UIColor.black
                label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
}
