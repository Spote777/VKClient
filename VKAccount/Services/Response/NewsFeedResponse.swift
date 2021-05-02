//
//  NewsFeedResponse.swift
//  VKAccount
//
//  Created by Павел Заруцков on 22.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation

struct NewsFeedResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var items: [NewsFeed]
        var profiles: [ProfileNews]?
        var groups: [GroupNews]?
        let next_from: String
    }
}

