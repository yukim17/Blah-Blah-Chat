//
//  CommunicationManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol UserConnectionTrackerProtocol {
    func changeControlsState(enabled: Bool)
}

protocol CommunicatorDelegate: class {
    var communicator: Communicator { get }
    var connectionTracker: UserConnectionTrackerProtocol? { get set }
    
    // discovery
    func didFoundUser(id: String, name: String)
    func didLostUser(id: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // message
    func didReceiveMessage(text: String, from user: String)
    func didSendMessage(text: String, to user: String)
    
    // conversation
    func didReadConversation(id: String)
}

class CommunicationService: CommunicatorDelegate {
    var communicator: Communicator
    private let dataManager: DataManager
    var connectionTracker: UserConnectionTrackerProtocol?
    
    init(dataManager: DataManager, communicator: Communicator) {
        self.dataManager = dataManager
        self.communicator = communicator
        self.communicator.delegate = self
    }
    
    func didFoundUser(id: String, name: String) {
        connectionTracker?.changeControlsState(enabled: true)
        dataManager.appendConversation(id: id, userName: name)
    }
    
    func didLostUser(id: String) {
        connectionTracker?.changeControlsState(enabled: false)
        dataManager.makeConversationOffline(id: id)
    }
    
    func didSendMessage(text: String, to user: String) {
        dataManager.appendMessage(text: text, conversationId: user, isIncoming: false)
    }
    
    func didReceiveMessage(text: String, from user: String) {
        dataManager.appendMessage(text: text, conversationId: user, isIncoming: true)
    }
    
    func didReadConversation(id: String) {
        dataManager.readConversation(id: id)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed To Start Browsing For Users:", error.localizedDescription)
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }
    
    func failedToStartAdvertising(error: Error) {
        print("Failed To Start Advertising:", error.localizedDescription)
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }
    
}
