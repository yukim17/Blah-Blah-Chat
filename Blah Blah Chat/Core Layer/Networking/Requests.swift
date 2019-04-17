//
//  Requests.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class SearchImagesRequest: RequestProtocol {
    
    private let key: String
    
    private let baseLink = "https://pixabay.com/api/"
    
    private var parameters = ["q": "palm+sky", "image_type": "photo", "pretty": "true", "per_page": "200"]
    
    private var urlString: String {
        parameters["key"] = key
        
        var formingString = String()
        
        for pair in parameters {
            formingString.append("\(pair.key)=\(pair.value)&")
        }
        
        return String("\(baseLink)?\(formingString.dropLast())")
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    init(key: String) {
        self.key = key
    }
    
}

class DownloadImageRequest: RequestProtocol {
    var urlString: String
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
}
