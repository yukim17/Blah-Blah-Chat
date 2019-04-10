//
//  ChatViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 24.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!

    var messages = [Message]()
    var communicationManager: CommunicationManager!
    var isOnline: Bool!
    var userName: String = "" {
        didSet {
            self.title = userName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.messagesTableView.addGestureRecognizer(tapGesture)

        if let messages = MessagesStorage.getMessages(from: userName) {
            self.messages = messages
        }
        if !isOnline {
            userBecomeOffline()
        }

        self.messageTextField.delegate = self
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self

        let nib = UINib(nibName: "IncomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "incomingMessage")

        let nib1 = UINib(nibName: "OutcomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib1, forCellReuseIdentifier: "outcomingMessage")

        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 50
    }
    
    func setupNoMessagesView() {
        if messages.isEmpty {
            let noMessagesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            noMessagesLabel.text = "Not messages yet"
            noMessagesLabel.textColor = UIColor.darkGray
            noMessagesLabel.font = UIFont.systemFont(ofSize: 14)
            noMessagesLabel.textAlignment = .center
            self.messagesTableView.tableHeaderView = noMessagesLabel
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.messagesTableView.scrollToBottom(animated: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func sendTapped(_ sender: Any) {
        guard let text = messageTextField.text,
            text != "" else { return }

        messageTextField.text = ""
        communicationManager.communicator.sendMessage(string: text, to: userName) { (_, error) in
            self.showAlert(title: "Error", message: error?.localizedDescription, retry: nil)
        }

        let outcomingMessage = Message(messageText: text, date: Date.init(timeIntervalSinceNow: 0), type: .outcoming)
        self.messages.append(outcomingMessage)

        self.messagesTableView.reloadData()
        self.messagesTableView.scrollToBottom(animated: true)

        MessagesStorage.addMessage(from: userName, message: outcomingMessage)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        var cell: MessageTableViewCell
        if message.type == .incoming {
            guard let incCell = tableView.dequeueReusableCell(withIdentifier: "incomingMessage", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
            cell = incCell
        } else {
            guard let outCell = tableView.dequeueReusableCell(withIdentifier: "outcomingMessage", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
            cell = outCell
        }

        cell.configureCell(message: message.messageText ?? "")

        return cell
    }

}

// MARK: - Show/hide Keyboard

extension ChatViewController {

    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.messageTextField.resignFirstResponder()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.view.frame.origin.y = -keyboardRectangle.height
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
}

extension ChatViewController: CommunicationManagerChatDelegate {

    func didRecieveMessage(message: Message) {
        DispatchQueue.main.async {
            if self.messages.isEmpty {
                self.messagesTableView.tableHeaderView = nil
            }
            self.messages.append(message)

            self.messagesTableView.reloadData()
            self.messagesTableView.scrollToBottom(animated: true)
        }
    }

    func userBecomeOffline() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
            self.sendButton.alpha = 0.5
        }
    }

    func userBecomeOnline() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = true
            self.sendButton.alpha = 1
        }
    }

}
