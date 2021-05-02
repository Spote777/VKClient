//
//  Session.swift
//  VKAccount
//
//  Created by Заруцков Павел on 26.09.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

final class Session {
    
    static let instance = Session()
    private init() {}
    
    var token: String?
    var userId: Int?
}
