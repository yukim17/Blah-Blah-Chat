//
//  TestData.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 24.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

let conversationList: [(String, String?, Date?, Bool, Bool)] = [
    ("Mike", "you have to get someone enthusiastic enough to want to do it for free :)", Date(timeIntervalSinceNow: 0), true, false),
    ("Jane", "I'm not sure, I can discuss with you what little I know", Date(timeIntervalSinceNow: -3260), true, false),
        ("Hanna", nil, nil, true, false),
        ("Tony", "hehe", Date(timeIntervalSinceNow: -2341), true, false),
        ("Sara", "yeah, no problems here", Date(timeIntervalSinceNow: -827364), true, true),
        ("Mia", "i suppose you don't normally do it with dev tools, it's just trial and error", Date(timeIntervalSinceNow: -84376), true, false),
        ("Nina", nil, nil, true, false),
        ("John", "it's a great dataset", Date(timeIntervalSinceNow: -2134354), true, false),
        ("Perry", nil, nil, true, false),
        ("Elliot", "too complicated", Date(timeIntervalSinceNow: -314), true, true),
        ("Dave", "cheers", Date(timeIntervalSinceNow: -63746), false, false),
        ("Peter", "I have a feeling they will, truth be told", Date(timeIntervalSinceNow: -4386521), false, true),
        ("Terry", "ok, so what's the deal?", Date(timeIntervalSinceNow: -2348732), false, true),
        ("Helen", nil, nil, false, false),
        ("Julia", "sounds good. what's the goal?", Date(timeIntervalSinceNow: -2364735), false, false),
        ("Jessy", "you know what I mean, right?", Date(timeIntervalSinceNow: -443636), false, true),
        ("Liza", nil, nil, false, false),
        ("Alex", nil, nil, false, false),
        ("Phil", "not sure why", Date(timeIntervalSinceNow: -239865), false, true),
        ("Mary", nil, nil, false, false)
]

func randomString(length: Int) -> String {
    let characters = " abcdefghijklmnopqrstuvwxyz"
    let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
    let randomString = String(randomCharacters)
    
    return randomString
}

func generateRandomMessages() -> [(String, MessageType)] {
    var resultArray: [(String, MessageType)] = []
    let number = Int(arc4random_uniform(10) + 10)
    for _ in 1...number {
        let messageLength =  Int.random(in: 10...200)
        let type =  Int.random(in: 0...1)
        let messageType = type == 0 ? MessageType.incoming : MessageType.outcoming
        resultArray.append((randomString(length: messageLength), messageType))
    }
    return resultArray
}

