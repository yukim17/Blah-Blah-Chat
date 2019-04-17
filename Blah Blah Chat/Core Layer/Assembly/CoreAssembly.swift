//
//  CoreAssembly.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 16.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var multipeerCommunicator: Communicator { get }
    var dataManager: DataManager { get }
    var themesManager: ThemesManagerProtocol { get }
    var coreDataStub: CoreDataStackProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    private let coreDataManager = CoreDataManager()
    lazy var multipeerCommunicator: Communicator = MultipeerCommunicator()
    lazy var themesManager: ThemesManagerProtocol = ThemesManager()
    lazy var dataManager: DataManager = coreDataManager
    lazy var coreDataStub: CoreDataStackProtocol = coreDataManager
}
