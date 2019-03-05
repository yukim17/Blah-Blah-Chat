//
//  Logger.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

enum ApplicationState: String {
    case notRunning = "not running"
    case inactive
    case active
    case background
    case suspended
}

class Logger {
    
    static let shared = Logger()
    
    func logState(function: String = #function, moveFrom state1: ApplicationState, to state2: ApplicationState) {
        #if DEBUG
            print("Application moved from \"\(state1.rawValue)\" to \"\(state2.rawValue)\": \(function)")
        #endif
    }
    
    func logState(function: String = #function, message: String) {
        #if DEBUG
            print("View controller calls \(function): \(message)")
        #endif
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        #if DEBUG
        print("Selected color is \(String(describing: selectedTheme.cgColor.components))")
        #endif
    }
}
