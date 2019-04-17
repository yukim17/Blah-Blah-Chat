//
//  FetchRequestService.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import CoreData

protocol FRServiceProtocol: class {
    func allConversations() -> NSFetchRequest<Conversation>?
    func messagesInConversation(with id: String) -> NSFetchRequest<Message>?
    
    var saveContext: NSManagedObjectContext { get }
}

class FetchRequestService: FRServiceProtocol {
    private let stack: CoreDataStackProtocol
    
    init(stack: CoreDataStackProtocol) {
        self.stack = stack
    }
    
    var saveContext: NSManagedObjectContext {
        return stack.saveContext
    }
    
    func allConversations() -> NSFetchRequest<Conversation>? {
        let name = NSSortDescriptor(key: "user.name", ascending: true)
        let date = NSSortDescriptor(key: "lastMessage.date", ascending: false)
        let online = NSSortDescriptor(key: "isOnline", ascending: false)
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        fetchRequest.sortDescriptors = [online, date, name]

        return fetchRequest
    }
    
    func messagesInConversation(with id: String) -> NSFetchRequest<Message>? {
        return stack.fetchRequest("MessagesByConv", substitutionDictionary: ["id": id], sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    }
    
}
