//
//  ConversationTableViewCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 22.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    private var dateValue: Date?
    private var onlineValue: Bool = false
    private var hasUnreadMessagesValue: Bool = false
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

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
        self.name = conversation.name
        self.message = conversation.message
        self.date = conversation.date
        self.online = conversation.online
        self.hasUnreadMessages = conversation.hasUnreadMessages
    }
    
}

extension ConversationTableViewCell: ConversationCellConfiguration {
    
    var name: String? {
        get {
            return self.nameLabel.text
        }
        set {
            self.nameLabel.text = newValue
        }
    }
    var message: String? {
        get {
            return self.messageLabel.text
        }
        set {
            if let textValue = newValue {
                self.messageLabel.text = textValue
                self.messageLabel.font = UIFont.systemFont(ofSize: self.messageLabel.font.pointSize)
            } else {
                self.messageLabel.text = "No messages yet"
                self.messageLabel.font = UIFont.italicSystemFont(ofSize: self.messageLabel.font.pointSize)
            }
        }
    }
    var date: Date? {
        get {
            return self.dateValue
        }
        set {
            if let date = newValue {
                self.dateValue = date
                self.dateLabel.text = date.toShortFormatString()
                self.dateLabel.isHidden = false
            } else {
                self.dateLabel.isHidden = true
            }
        }
    }
    var online: Bool {
        get {
            return self.onlineValue
        }
        set {
            self.onlineValue = newValue
            if newValue {
                self.backgroundColor = Colors.lightYellow
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    var hasUnreadMessages: Bool {
        get {
            return self.hasUnreadMessagesValue
        }
        set {
            self.hasUnreadMessagesValue = newValue
            if newValue {
                self.messageLabel.font = UIFont.boldSystemFont(ofSize: self.messageLabel.font.pointSize)
                self.messageLabel.textColor = UIColor.black
            } else {
                self.messageLabel.font = UIFont.systemFont(ofSize: self.messageLabel.font.pointSize)
            }
        }
    }
}
