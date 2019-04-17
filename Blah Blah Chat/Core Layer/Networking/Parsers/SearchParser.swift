//
//  SearchParser.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

struct Response: Codable {
    let hits: [Picture]
}

class SearchImagesParser: ParserProtocol {
    typealias Model = [Picture]
    
    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Response.self, from: data).hits
        } catch {
            print("Error trying to convert data to JSON SearchParser")
            return nil
        }
    }
}
