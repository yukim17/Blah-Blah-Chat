//
//  ConversationsListViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 20.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    var onlineConversations = [Conversation]()
    var offlineConversations = [Conversation]()

    var communicationManager = CommunicationManager()
    
    @IBOutlet var convListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.communicationManager.usersDelegate = self

        self.convListTableView.delegate = self
        self.convListTableView.dataSource = self
        
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        self.convListTableView.register(nib, forCellReuseIdentifier: "chatCell")
        
        self.convListTableView.rowHeight = UITableView.automaticDimension
        self.convListTableView.estimatedRowHeight = 67
    }
    
    @IBAction func showProfile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "viewProfile", sender: self)
    }
    
    @IBAction func showThemeSettings(_ sender: UIBarButtonItem) {
        #if DEBUG
            self.performSegue(withIdentifier: "showThemesObjC", sender: self)
        #else
            self.performSegue(withIdentifier: "showThemesSwift", sender: self)
        #endif
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let vc = segue.destination as! ChatViewController
            let indexPath = self.convListTableView.indexPathForSelectedRow!
            let selectedItem = indexPath.section == 0 ?
                self.onlineConversations[indexPath.row] :
                self.offlineConversations[indexPath.row]
            vc.title = selectedItem.name
            self.convListTableView.deselectRow(at: indexPath, animated: true)
        } else if segue.identifier == "showThemesObjC" {
            let vc = segue.destination as! ThemesViewController
            vc.delegate = self
        } else if segue.identifier == "showThemesSwift" {
            let vc = segue.destination as! ThemesViewControllerSwift
            vc.closure = { [weak self] in self?.logThemeChanging }()
        }
    }

}

// MARK: - Table View Delegate Methods

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath) as! ConversationTableViewCell

        switch indexPath.section {
        case 0:
            //conversationVC.isOnline = true
            onlineConversations[indexPath.row].hasUnreadMessages = false
        case 1:
            //conversationVC.isOnline = false
            offlineConversations[indexPath.row].hasUnreadMessages = false
        default:
            break
        }
        
        //conversationVC.userName = selectedCell.name
        //conversationVC.communicationManager = communicationManager
        //communicationManager.chatDelegate = conversationVC
        
        //navigationController?.pushViewController(conversationVC, animated: true)
        
        self.performSegue(withIdentifier: "showChat", sender: self)
    }
}

// MARK: - Table View Datasource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.onlineConversations.count
        }
        return self.offlineConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ConversationTableViewCell
        
        var conversation: Conversation
        
        if indexPath.section == 0 {
            conversation = onlineConversations[indexPath.row]
        } else {
            conversation = offlineConversations[indexPath.row]
        }
        
        cell.configureCell(conversation: conversation)
        
        return cell
    }
}

extension ConversationsListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        Logger.shared.logThemeChanging(selectedTheme: selectedTheme)
        setThemeColor(color: selectedTheme)
    }
    
    func logThemeChanging(selectedColor: UIColor) {
        Logger.shared.logThemeChanging(selectedTheme: selectedColor)
        setThemeColor(color: selectedColor)
    }
    
    func setThemeColor(color: UIColor) {
        UINavigationBar.appearance().barTintColor = color
        UserDefaults.standard.setColor(color: color, forKey: "ThemeColor")
    }
    
}

extension ConversationsListViewController: CommunicationManagerUsersDelegate {
    
    func dateAndName(_ left: Conversation, _ right: Conversation) -> Bool {
        guard let leftDate = left.date,
            let rightDate = right.date else {
                return left.name! < right.name!
                
        }
        return leftDate < rightDate
    }
    
    func updateConversations(_ conversations: [Conversation]) {
        for conversation in conversations {
            guard let lastMessage = MessagesStorage.getMessages(from: conversation.name!)?.last else {
                conversation.hasUnreadMessages = false
                continue
            }
            conversation.message = lastMessage.messageText
            conversation.date = lastMessage.date
        }
    }
    
    func updateConversationList() {
        updateConversations(self.onlineConversations)
        updateConversations(self.offlineConversations)
        
        self.onlineConversations = self.onlineConversations.sorted(by: dateAndName)
        self.offlineConversations = self.offlineConversations.sorted(by: dateAndName)
        
        DispatchQueue.main.async {
            self.convListTableView.reloadData()
        }
    }
    
}
