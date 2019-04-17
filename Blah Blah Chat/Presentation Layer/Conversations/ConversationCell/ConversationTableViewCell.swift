//
//  ConversationTableViewCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 22.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var lastMessageText: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    var name: String? {
        didSet {
            nameLabel.text = name ?? "Name"
        }
    }
    
    var lastMessageText: String? {
        didSet {
            if let textValue = lastMessageText {
                self.messageLabel.text = textValue
                self.messageLabel.font = UIFont.systemFont(ofSize: self.messageLabel.font.pointSize)
            } else {
                self.messageLabel.text = "No messages yet"
                self.messageLabel.font = UIFont.italicSystemFont(ofSize: self.messageLabel.font.pointSize)
            }
        }
    }
    
    var date: Date? {
        didSet {
            if let date = date {
                self.dateLabel.text = date.toShortFormatString()
                self.dateLabel.isHidden = false
            } else {
                self.dateLabel.isHidden = true
            }
        }
    }
    
    var online = false {
        didSet {
            if online {
                self.backgroundColor = Colors.lightYellow
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages = false {
        didSet {
            if hasUnreadMessages {
                self.messageLabel.font = UIFont.boldSystemFont(ofSize: self.messageLabel.font.pointSize)
                self.messageLabel.textColor = UIColor.black
            } else {
                self.messageLabel.font = UIFont.systemFont(ofSize: self.messageLabel.font.pointSize)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configureCell(conversation: Conversation) {
        self.online = conversation.isOnline
        self.date = conversation.lastMessage?.date ?? nil
        self.lastMessageText = conversation.lastMessage?.messageText ?? nil
        self.hasUnreadMessages = conversation.hasUnreadMessages
    }
}
