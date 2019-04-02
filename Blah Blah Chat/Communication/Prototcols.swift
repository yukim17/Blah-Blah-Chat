//
//  Prototcols.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 14.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol CommunicatorDelegate: class {
    // discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    // messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}
