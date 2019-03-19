//
//  MessageStorage.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 19.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class MessagesStorage {
    
    static private var messages = [String: [Message]]()
    
    static func getMessages(from userName: String) -> [Message]? {
        let messagesDict = MessagesStorage.messages as NSDictionary
        let messages = messagesDict.value(forKey: userName) as? [Message]
        
        return messages
    }
    
    static func addMessage(from userName: String, message: Message) {
        if let _ = MessagesStorage.getMessages(from: userName) {
            MessagesStorage.messages[userName]?.append(message)
        } else {
            MessagesStorage.messages[userName] = [message]
        }
    }
    
    
}

