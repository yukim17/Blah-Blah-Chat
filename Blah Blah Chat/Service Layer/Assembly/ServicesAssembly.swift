//
//  ServicesAssembly.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 15.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var frService: FRServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var communicationService: CommunicatorDelegate { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }

    lazy var frService: FRServiceProtocol = FetchRequestService(stack: coreAssembly.coreDataStub)
    lazy var communicationService: CommunicatorDelegate = CommunicationService(dataManager: coreAssembly.dataManager, communicator: coreAssembly.multipeerCommunicator)
    lazy var themesService: ThemesServiceProtocol = ThemesService(themesManager: coreAssembly.themesManager)
    
}
