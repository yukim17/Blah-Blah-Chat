////
////  LoadOperation.swift
////  Blah Blah Chat
////
////  Created by Екатерина on 13.03.2019.
////  Copyright © 2019 Wineapp. All rights reserved.
////
//
//import Foundation
//
//class LoadProfileOperation: Operation {
//
//    private let profileHandler: ProfileHandler
//    var profile: ProfileData?
//
//    init(profileHandler: ProfileHandler) {
//        self.profileHandler = profileHandler
//        super.init()
//    }
//
//    override func main() {
//        if self.isCancelled { return }
//        self.profile = self.profileHandler.loadData()
//    }
//}
