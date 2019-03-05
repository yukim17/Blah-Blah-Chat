//
//  ConversationsListViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 20.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    // [name, message, date, online, hasUnreadMessages]
    var onlineConversations: [(String, String?, Date?, Bool, Bool)] = []
    var offlineConversations: [(String, String?, Date?, Bool, Bool)] = []
    
    @IBOutlet var convListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onlineConversations = conversationList.filter({ $0.3 }).sorted(by: { first, second in
            return first.4
        }).sorted(by: { first, second in
            let value1 = first.2?.timeIntervalSinceNow ?? -Double(Int.max)
            let value2 = second.2?.timeIntervalSinceNow ?? -Double(Int.max)
            return value1 > value2
        })
        self.offlineConversations = conversationList.filter({ !$0.3 }).sorted(by: { first, second in
            return first.4
        }).sorted(by: { first, second in
            let value1 = first.2?.timeIntervalSinceNow ?? -Double(Int.max)
            let value2 = second.2?.timeIntervalSinceNow ?? -Double(Int.max)
            return value1 > value2
        })

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
            vc.title = selectedItem.0
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
        
        var conversation: (String, String?, Date?, Bool, Bool)
        
        if indexPath.section == 0 {
            conversation = onlineConversations[indexPath.row]
        } else {
            conversation = offlineConversations[indexPath.row]
        }
        
        cell.configureCell(
            name: conversation.0,
            message: conversation.1,
            date: conversation.2,
            online: conversation.3,
            hasUnreadMessages: conversation.4)
        
        return cell
    }
    
}

extension ConversationsListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        Logger.shared.logThemeChanging(selectedTheme: selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        //UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
    }
    
    func logThemeChanging(selectedColor: UIColor) {
        Logger.shared.logThemeChanging(selectedTheme: selectedColor)
        UINavigationBar.appearance().barTintColor = selectedColor
    }
    
    func setThemeColor(color: UIColor) {
        UINavigationBar.appearance().barTintColor = color
    }
    
}
