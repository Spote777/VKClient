//
//  Group.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//
import Foundation
import RealmSwift

final class Groups: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screen_name: String = ""
    @objc dynamic var photo: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screen_name
        case photo = "photo_100"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.screen_name = try container.decode(String.self, forKey: .screen_name)
        self.photo = try container.decode(String.self, forKey: .photo)
    }
    
    static func ==(lhs: Groups, rhs: Groups) -> Bool {
        return lhs.name == rhs.name
    }
}
