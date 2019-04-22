//
//  ChatModel.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 16.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import CoreData

protocol ChatModelProtocol: class {
    
    var communicationService: CommunicatorDelegate { get set }
    var conversation: Conversation { get set }
}

class ChatModel: ChatModelProtocol {
    
    let frService: FRServiceProtocol
    var communicationService: CommunicatorDelegate
    var conversation: Conversation
    var dataSource: MessagesDataSource?
    
    func makeRead() {
        guard let id = conversation.conversationId else { return }
        communicationService.didReadConversation(id: id)
    }
    
    init(communicationService: CommunicatorDelegate,
         frService: FRServiceProtocol,
         conversation: Conversation) {
        self.communicationService = communicationService
        self.frService = frService
        self.conversation = conversation
    }
    
    // MARK: - UserConnectionTracker
    func setUserConnectionTracker(_ tracker: UserConnectionTrackerProtocol) {
        self.communicationService.connectionTracker = tracker
    }
}
