//
//  NewsFeed.swift
//  VKAccount
//
//  Created by Павел Заруцков on 17.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

struct NewsFeed: Decodable {
    var sourceID: Int!
    var date: Double
    var text: String?
    var attachments: [Attachment]?
    var postType: String!
    var avatarUrl: String?
    var creatorName: String?
    var likes: Likes?
    var views: Views?
    var photosUrl: [String]? {
        get {
            let photosUrl = attachments?.compactMap{ $0.photo?.sizes.first?.url }
            return photosUrl
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case likes
        case views
        case text
        case attachments
        case postType = "post_type"
    }
}

struct Attachment: Decodable {
    var photo: Photo?
}

struct Photo: Decodable {
    var date, id, ownerID: Int
    var sizes: [Size]
    var text: String
    
    
    enum CodingKeys: String, CodingKey {
        case date
        case id
        case ownerID = "owner_id"
        case sizes, text
    }
}

struct Size: Decodable {
    var url: String
    var type: String
    var height: Int
    var width: Int
    
    var aspectRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }
    
    enum CodingKeys: String, CodingKey {
        case url, type
        case height, width
    }
}

struct Likes: Decodable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct Views: Decodable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct ProfileNews: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let photo_100: String
    
    var fullName: String {
        return "\(first_name ) \(last_name )"
    }
}
struct GroupNews: Decodable {
    let id: Int
    let name: String
    let photo_100: String
}

