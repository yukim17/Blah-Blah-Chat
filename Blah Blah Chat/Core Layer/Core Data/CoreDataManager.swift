//
//  CoreDataManager.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import CoreData
import UIKit

protocol DataManager: class {
    func appendMessage(text: String, conversationId: String, isIncoming: Bool)
    func appendConversation(id: String, userName: String)
    func makeConversationOffline(id: String)
    func readConversation(id: String)
    func loadAppUser(completion: @escaping (AppUserData?) -> ())
    func saveAppUser(_ profile: AppUserData, completion: @escaping (Bool) -> ())
    
}

protocol CoreDataStackProtocol: class {
    var saveContext: NSManagedObjectContext { get }
    func fetchRequest<T>(_ fetchRequestName: String,
                         substitutionDictionary: [String: Any]?,
                         sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<T>? where T: NSManagedObject
}

class CoreDataManager: DataManager, CoreDataStackProtocol {
    private let stack: CoreDataStack
    
    init() {
        stack = CoreDataStack()
    }
    
    var saveContext: NSManagedObjectContext {
        return stack.saveContext
    }
    
    // MARK: - DataManager Protocol
    func loadAppUser(completion: @escaping (AppUserData?) -> ()) {
        guard let appUser: AppUser = findOrInsert(entityName: "AppUser") else {
            completion(nil)
            return
        }

        let profile = Profile()
        profile.name = appUser.name
        profile.description = appUser.descr
        if let picture = appUser.photo {
            profile.picture = UIImage(data: picture)
        }
        completion(profile)
    }

    func saveAppUser(_ profile: AppUserData, completion: @escaping (Bool) -> ()) {
        let appUser: AppUser? = findOrInsert(entityName: "AppUser")
        appUser?.name = profile.name
        appUser?.descr = profile.description

        if let picture = profile.picture {
            appUser?.photo = picture.jpegData(compressionQuality: 1.0)
        }

        stack.performSave(with: stack.saveContext) { error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func readConversation(id: String) {
        guard let conversation: Conversation = withId(id, requestName: "ConversationById")
            else { return }
        conversation.hasUnreadMessages = false
        performSave()
    }
    
    
    func appendConversation(id: String, userName: String) {
        let conversation: Conversation? = withId(id, requestName: "ConversationById")
        guard conversation == nil else {
            conversation?.isOnline = true
            performSave()
            return
        }
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User",
                                                       into: stack.saveContext) as! User
        user.userId = id
        user.name = userName
        user.isOnline = true
        
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Conversation",
                                                       into: stack.saveContext) as! Conversation
        chat.conversationId = id
        chat.isOnline = true
        chat.hasUnreadMessages = false
        chat.lastMessage = nil
        chat.user = user
        chat.profile = nil
        user.addToConversations(chat)
        
        performSave()
    }
    
    
    func makeConversationOffline(id: String) {
        guard let user: User = withId(id, requestName: "UserById"),
            let conversation: Conversation = withId(id, requestName: "ConversationById")
            else { return }
        
        if conversation.lastMessage != nil {
            conversation.isOnline = false
        } else {
            stack.saveContext.delete(conversation)
            stack.saveContext.delete(user)
        }
        
        performSave()
    }
    
    
    func appendMessage(text: String, conversationId: String, isIncoming: Bool) {
        guard let conversation: Conversation = withId(conversationId, requestName: "ConversationById")
            else { return }
        
        let message: Message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: stack.saveContext) as! Message
        message.messageId = Message.generateMessageId()
        message.date = Date()
        message.isIncoming = isIncoming
        message.messageText = text
        message.conversation = conversation
        message.convLastMessage = conversation
        
        conversation.hasUnreadMessages = isIncoming
        
        performSave()
    }
    
    
    func fetchRequest<T>(_ fetchRequestName: String,
                         substitutionDictionary: [String: Any]? = nil,
                         sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<T>? where T: NSManagedObject {
        let request: NSFetchRequest<T>?
        
        request = substitutionDictionary == nil ?
            stack.managedObjectModel.fetchRequestTemplate(forName: fetchRequestName) as? NSFetchRequest<T> :
            stack.managedObjectModel.fetchRequestFromTemplate(withName: fetchRequestName, substitutionVariables: substitutionDictionary!) as? NSFetchRequest<T>
        request?.sortDescriptors = sortDescriptors
        
        guard request != nil else {
            assert(false, "No template with name \(fetchRequestName) exists")
            return nil
        }
        
        return request
    }
    
    
    private func performSave() {
        stack.performSave(with: stack.saveContext) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    
    private func findOrInsert<T>(entityName: String) -> T? where T: NSManagedObject {
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        guard var object = try? stack.saveContext.fetch(request).first else {
            return nil
        }
        
        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: stack.mainContext) as? T
        }
        
        return object
    }
    
    
    private func withId<T>(_ id: String, requestName: String) -> T? where T: NSManagedObject {
        guard let request: NSFetchRequest<T> =
            fetchRequest(requestName, substitutionDictionary: ["id": id]),
            let object = try? stack.saveContext.fetch(request).first else { return nil }
        
        return object
    }
    
}

