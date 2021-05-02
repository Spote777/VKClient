//
//  PhotosResponse.swift
//  VKAccount
//
//  Created by Павел Заруцков on 30.11.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct PhotosResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var count: Int
        var items: [Items]
        
        struct Items: Decodable {
            var id: Int
            var owner_id: Int
            var sizes: [Sizes]
            
            struct Sizes: Decodable {
                var height: Int
                var url: String
                var width: Int
            }
        }
    }
}
