//
//  Message.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 19.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

enum MessageType {
    case incoming
    case outcoming
}

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}

class Message: MessageCellConfiguration {
    var messageText: String?
    var date: Date?
    var type: MessageType

    init(messageText: String?, type: MessageType) {
        self.messageText = messageText
        self.type = type
    }

    init(messageText: String?, date: Date?, type: MessageType) {
        self.messageText = messageText
        self.date = date
        self.type = type
    }
}
