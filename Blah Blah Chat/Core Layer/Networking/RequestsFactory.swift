//
//  RequestsFactory.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 17.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixabayRequests {
        private static let apiKey = "12226226-b36092e3b9d1c2c414f89a5c5"
        
        static func searchImages() -> RequestConfig<SearchImagesParser> {
            let request = SearchImagesRequest(key: apiKey)
            let parser = SearchImagesParser()
            return RequestConfig<SearchImagesParser>(request: request, parser: parser)
        }
        
        static func downloadImage(urlString: String) -> RequestConfig<DownloadImageParser> {
            let request = DownloadImageRequest(urlString: urlString)
            let parser = DownloadImageParser()
            return RequestConfig<DownloadImageParser>(request: request, parser: parser)
        }
        
    }
    
}
