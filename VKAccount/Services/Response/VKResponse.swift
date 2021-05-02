//
//  VKResponse.swift
//  VKAccount
//
//  Created by Павел Заруцков on 07.12.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct VKResponse<T: Decodable>: Decodable {
    var count: Int
    var items: [T]
    
    enum CodingKeys: String, CodingKey {
        case response
        case count
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: CodingKeys.self,forKey: .response)
        
        self.count = try responseContainer.decode(Int.self, forKey: .count)
        self.items = try responseContainer.decode([T].self, forKey: .items)
    }
    
   
}
