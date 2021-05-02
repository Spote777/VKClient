//
//  RealmManager.swift
//  VKAccount
//
//  Created by Павел Заруцков on 08.02.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    func saveToRealm<T: Object>(_ object: [T]) {
        do {
            let realm = try Realm()
            let oldValue = realm.objects(T.self)
            realm.beginWrite()
            realm.delete(oldValue)
            realm.add(object)
            try realm.commitWrite()
            //print(Realm.Configuration.defaultConfiguration.fileURL)
        } catch {
            print(error)
        }
    }
}
