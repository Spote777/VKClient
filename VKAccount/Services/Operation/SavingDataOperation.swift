//
//  SavingDataOperation.swift
//  VKAccount
//
//  Created by Павел Заруцков on 23.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation
import RealmSwift

class SavingDataOperation: Operation {
    
    override func main() {
        guard let parseDataOperation = dependencies.first as? ParseDataOperation,
              let outputData = parseDataOperation.outputData else { return }
        
        do {
            let realm = try Realm()
            let oldValues = realm.objects(Groups.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(outputData)
            try realm.commitWrite()
            
            print("Completed Saving")
        } catch {
            print(error)
        }
    }
}
