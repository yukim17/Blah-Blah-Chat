//
//  NetworkingProtocols.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

protocol RequestSenderProtocol {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
