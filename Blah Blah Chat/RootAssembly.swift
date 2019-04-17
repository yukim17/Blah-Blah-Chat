//
//  RootAssembly.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class RootAssembly {
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
    private lazy var serviceAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: self.coreAssembly)
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
}
