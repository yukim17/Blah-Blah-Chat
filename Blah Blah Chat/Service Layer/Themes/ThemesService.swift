//
//  ThemesService.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

protocol ThemesServiceProtocol: class {
    func save(_ theme: UIColor)
    func load()
}

class ThemesService: ThemesServiceProtocol {
    private let themesManager: ThemesManagerProtocol
    
    init(themesManager: ThemesManagerProtocol) {
        self.themesManager = themesManager
    }

    func save(_ theme: UIColor) {
        themesManager.apply(theme, save: true)
    }

    func load() {
        themesManager.loadAndApply()
    }

}
