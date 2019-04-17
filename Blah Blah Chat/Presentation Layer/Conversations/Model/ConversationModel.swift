//
//  Conversation.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 19.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol ConversationModelProtocol: class {
    var communicationService: CommunicatorDelegate { get }
    var frService: FRServiceProtocol { get }
    var dataSource: ConversationDataSource? { get set }
    
    func reloadThemeSettings()
    func saveSettings(for theme: UIColor)
}

class ConversationModel: ConversationModelProtocol {
    
    var dataSource: ConversationDataSource?
    var communicationService: CommunicatorDelegate
    var frService: FRServiceProtocol
    private let themesService: ThemesServiceProtocol
    
    init(communicationService: CommunicatorDelegate,
         themesService: ThemesServiceProtocol,
         frService: FRServiceProtocol) {
        self.communicationService = communicationService
        self.themesService = themesService
        self.frService = frService
    }
    
    func reloadThemeSettings() {
        themesService.load()
    }
    
    func saveSettings(for theme: UIColor) {
        themesService.save(theme)
    }
}

