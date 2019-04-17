//
//  ModelExtension.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

extension Message: MessageCellConfiguration {
    
    @nonobjc class func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
    }
    
}
