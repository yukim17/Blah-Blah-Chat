//
//  CommunicationManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol CommunicationManagerUsersDelegate {
    var onlineConversations: [Conversation] {get set}
    var offlineConversations: [Conversation] {get set}
    
    func updateConversationList()
}

protocol CommunicationManagerChatDelegate {
    var userName: String {get}
    
    func didRecieveMessage(message: Message)
    func userBecomeOffline()
    func userBecomeOnline()
}


class CommunicationManager {
    var usersDelegate: CommunicationManagerUsersDelegate?
    var chatDelegate: CommunicationManagerChatDelegate?
    
    var communicator = MultipeerCommunicator(online: true)
    
    init() {
        self.communicator.delegate = self
    }
    
    
}



extension CommunicationManager: CommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {
        if usersDelegate != nil {
            if !usersDelegate!.onlineConversations.isEmpty {
                for i in 0...usersDelegate!.onlineConversations.count - 1 {
                    let conversation = usersDelegate!.onlineConversations[i]
                    if conversation.name == userName {
                        return
                    }
                }
            }
            
            if !usersDelegate!.offlineConversations.isEmpty {
                for i in 0...usersDelegate!.offlineConversations.count - 1 {
                    let conversation = usersDelegate!.offlineConversations[i]
                    if conversation.name == userName {
                        usersDelegate!.offlineConversations.remove(at: i)
                        conversation.online = true
                        usersDelegate?.onlineConversations.append(conversation)
                        usersDelegate!.updateConversationList()
                        return
                    }
                }
            }
            
            let lastMessage = MessagesStorage.getMessages(from: userName!)?.last?.messageText
            let newConversations = Conversation(name: userName ?? "Anonymous", message: lastMessage, date: nil, online: true, hasUnreadMessages: false)
            
            usersDelegate!.onlineConversations.append(newConversations)
            usersDelegate!.updateConversationList()
        }
        
        if userID == chatDelegate?.userName {
            chatDelegate?.userBecomeOnline()
        }
    }
    
    func didLostUser(userID: String) {
        if usersDelegate != nil  &&  !usersDelegate!.onlineConversations.isEmpty {
            for i in 0...usersDelegate!.onlineConversations.count - 1 {
                let convarsation = usersDelegate!.onlineConversations[i]
                if convarsation.name == userID {
                    usersDelegate!.onlineConversations.remove(at: i)
                    convarsation.online = false
                    usersDelegate!.offlineConversations.append(convarsation)
                    usersDelegate!.updateConversationList()
                    break
                }
            }
        }
        
        if userID == chatDelegate?.userName {
            chatDelegate?.userBecomeOffline()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        
        let incomingMessage = Message(messageText: text, date: Date.init(timeIntervalSinceNow: 0), type: .incoming)
        MessagesStorage.addMessage(from: fromUser, message: incomingMessage)
        
        usersDelegate?.updateConversationList()
        
        
        if toUser == communicator.myPeerID.displayName && fromUser == chatDelegate?.userName {
            chatDelegate?.didRecieveMessage(message: incomingMessage)
        }
        
    }
    
}
