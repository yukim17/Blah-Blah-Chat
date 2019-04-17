//
//  RequestSender.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

class RequestSender: RequestSenderProtocol {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: ParserProtocol {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(.error(error.localizedDescription))
                return
            }
            
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.error("data can't be parsed"))
                    return
            }
            completionHandler(.success(parsedModel))
        }
        task.resume()
    }
}
