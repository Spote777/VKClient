//
//  ParseDataOperation.swift
//  VKAccount
//
//  Created by Павел Заруцков on 23.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation

class ParseDataOperation: Operation {
    
    var outputData: [Groups]?
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let dataParsed = try? decoder.decode(VKResponse<Groups>.self, from: data).items else { return }
        outputData = dataParsed
    }
}
