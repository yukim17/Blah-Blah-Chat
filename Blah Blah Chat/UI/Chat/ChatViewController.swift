//
//  ChatViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 24.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messages: [(String, MessageType)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.messages = generateRandomMessages()
        
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        
        let nib = UINib(nibName: "IncomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "incomingMessage")
        
        let nib1 = UINib(nibName: "OutcomingMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(nib1, forCellReuseIdentifier: "outcomingMessage")
        
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 50
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let indexPath = IndexPath(
            row: self.messagesTableView.numberOfRows(inSection:  self.messagesTableView.numberOfSections - 1) - 1,
            section: self.messagesTableView.numberOfSections - 1)
        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        var cell: MessageTableViewCell
        if message.1 == .incoming {
            cell = tableView.dequeueReusableCell(withIdentifier: "incomingMessage", for: indexPath) as! MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outcomingMessage", for: indexPath) as! MessageTableViewCell
        }
        
        cell.configureCell(message: message.0)
        
        return cell
    }
    
}
