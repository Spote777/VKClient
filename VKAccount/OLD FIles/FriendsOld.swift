//
//  Friends.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//
import Foundation
import RealmSwift

final class Friends: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String? = nil
    @objc dynamic var lastName: String? = nil
    @objc dynamic var photo: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_100"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.photo = try container.decode(String.self, forKey: .photo)
    }
}
