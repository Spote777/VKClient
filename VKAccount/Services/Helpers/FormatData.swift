//
//  FormatData.swift
//  VKAccount
//
//  Created by Павел Заруцков on 26.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation

class FormatData {
    
    var dateTextCache: [IndexPath: String] = [:]
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    func getCellDateText(forIndexPath indexPath: IndexPath, andTimestamp timestamp: Double) -> String {
        if let stringDate = dateTextCache[indexPath] {
            return stringDate
        } else {
            let date = Date(timeIntervalSince1970: timestamp)
            let stringDate = dateFormatter.string(from: date)
            dateTextCache[indexPath]  = stringDate
            return stringDate
        }
    }
}
