//
//  MultipeerCommunicator.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    var delegate: CommunicatorDelegate?
    
    var online: Bool
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    var sessions = [String: MCSession]()
    
    let advertiser: MCNearbyServiceAdvertiser
    let browser : MCNearbyServiceBrowser
    
    init(online: Bool) {
        let profile = GCDDataManager().syncLoadProfile()
        let username = profile?.name ?? "Anonymous"
        
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["userName" : username], serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: "tinkoff-chat")
        self.online = online
        
        super.init()
        
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        
        self.advertiser.delegate = self
        self.browser.delegate = self
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        guard let session = findSession(for: userID) else { return }
        
        let dict = [
            "eventType": "TextMessage",
            "messageId": generateMessageId(),
            "text": string
        ]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("Error: \(error)")
            }
        } else {
            print("No peers in this session")
        }
    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func findSession(for userID: String) -> MCSession? {
        if let session = (sessions as NSDictionary).value(forKey: userID) as? MCSession {
            return session
        }
        return nil
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if let session = findSession(for: peerID.displayName) {
            invitationHandler(true, session)
        } else {
            let session = MCSession(peer: myPeerID)
            invitationHandler(true, session)
            session.delegate = self
            sessions[peerID.displayName] = session
        }
        
    }
}


extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = MCSession(peer: myPeerID)
        session.delegate = self
        sessions[peerID.displayName] = session
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        
        let userName = (info as NSDictionary?)?.value(forKey: "userName") as? String ?? peerID.displayName
        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost \(peerID)")
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("error: \(error)")
    }
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("connected to session: \(session)")
            delegate?.didFoundUser(userID: peerID.displayName, userName: peerID.displayName)
        case MCSessionState.connecting:
            print("start connecting to session: \(session)")
        default:
            print("failed connecting to session: \(session)")
            //            delegate?.didLostUser(userID: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary,
            let text = dict.value(forKey: "text") as? String else { return }
        
        delegate?.didRecieveMessage(text: text, fromUser: peerID.displayName, toUser: myPeerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("start stream \(streamName) from \(peerID)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("start recieve resource \(resourceName) from \(peerID)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("finish recieve resource \(resourceName) from \(peerID)")
        
    }
    
    
}
