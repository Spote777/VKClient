//
//  FriendPhotos.swift
//  VKAccount
//
//  Created by Павел Заруцков on 12.12.2020.
//  Copyright © 2020 Павел. All rights reserved.
//
import Foundation
import RealmSwift

final class FriendPhotos: Object, Decodable {
    var sizes = List<SizePhoto>()
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case sizes
        case id
        case ownerId = "owner_id"
    }

final class SizePhoto: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String? = nil
    @objc dynamic var width: Int = 0
}
