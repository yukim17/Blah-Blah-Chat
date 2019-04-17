//
//  MessageTableViewCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 28.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration {
    var messageText: String? { get set }
    var isIncoming: Bool { get set }
}

class MessageTableViewCell: UITableViewCell, MessageCellConfiguration {

    @IBOutlet var messageLabel: UILabel!
    
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }
    
    var isIncoming = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(message: Message) {
        self.messageText = message.messageText
        self.isIncoming = message.isIncoming
    }
}
