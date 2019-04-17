//
//  PresentationAssembly.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 16.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewControllerSwift
    func profileViewController() -> ProfileViewController
    func conversationsListViewController() -> ConversationsListViewController
    func chatViewController(model: ChatModel) -> ChatViewController
    func picturesViewController() -> PicturesViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewControllerSwift {
        return ThemesViewControllerSwift(model: themesModel(closure))
    }
    
    private func themesModel(_ closure: @escaping ColorAlias) -> ThemesModelProtocol {
        return ThemesModel(theme1: #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1), theme2: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1), theme3: #colorLiteral(red: 0.8588235294, green: 0.9176470588, blue: 1, alpha: 1), closure: closure)
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(model: profileModel(), presentationAssembly: self)
    }
    
    private func profileModel() -> AppUserModelProtocol {
        return ProfileModel(dataService: CoreDataManager())
    }

    func chatViewController(model: ChatModel) -> ChatViewController {
        return ChatViewController(model: model)
    }

    func conversationsListViewController() -> ConversationsListViewController {
        return ConversationsListViewController(model: conversationsListModel(),
                                               presentationAssembly: self)
    }
    
    private func conversationsListModel() -> ConversationModelProtocol {
        return ConversationModel(communicationService: serviceAssembly.communicationService,
                                      themesService: serviceAssembly.themesService,
                                      frService: serviceAssembly.frService)
    }
    
    func picturesViewController() -> PicturesViewController {
        return PicturesViewController(model: picturesModel())
    }
    
    private func picturesModel() -> PicturesModelProtocol {
        return PicturesModel(picturesService: serviceAssembly.picturesService)
    }
}
