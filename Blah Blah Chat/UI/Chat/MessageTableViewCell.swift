//
//  MessageTableViewCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 28.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: String) {
        self.messageText = message
    }
}

extension MessageTableViewCell: MessageCellConfiguration {
    
    var messageText: String? {
        get {
            return messageLabel.text
        }
        set {
            self.messageLabel.text = newValue
        }
    }
}
