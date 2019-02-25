//
//  MessageTableViewCell.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 22.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

enum MessageType {
    case incoming
    case outcoming
}

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var message: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.message.backgroundColor = UIColor.clear
    }
    
    func configureCell(message: String) {
        self.messageText = message
    }
    
}

extension MessageTableViewCell: MessageCellConfiguration {
    
   var messageText: String? {
        get {
            return message.text
        }
        set {
            self.message.text = newValue
        }
    }
}
