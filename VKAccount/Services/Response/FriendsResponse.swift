//
//  FriendsResponse.swift
//  VKAccount
//
//  Created by Павел Заруцков on 30.11.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct FriendsResponse: Decodable {
    var response: Response

    struct Response: Decodable {
        var count: Int
        var items: [Items]

        struct Items: Decodable {
            var id: Int
            var first_name: String
            var last_name: String
            var photo_100: String
        }
    }
}
