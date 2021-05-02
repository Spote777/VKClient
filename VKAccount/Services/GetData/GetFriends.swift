//
//  GetFriends.swift
//  VKAccount
//
//  Created by Павел Заруцков on 09.02.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation

class GetFriends {
    
    func loadData(complition: @escaping ([Friends]) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.instance.userId ?? 0)),
            URLQueryItem(name: "fields", value: "photo_100"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            //            print("Запрос к API: \(urlConstructor.url!)")
            
            guard let data = data else { return }
            
            do {
                let arrayFriends = try JSONDecoder().decode(FriendsResponse.self, from: data)
                var fullNamesFriends: [Friends] = []
                for i in 0...arrayFriends.response.items.count-1 {
                    let name = ((arrayFriends.response.items[i].first_name) + " " + (arrayFriends.response.items[i].last_name))
                    let avatar = arrayFriends.response.items[i].photo_100
                    let id = String(arrayFriends.response.items[i].id)
                    fullNamesFriends.append(Friends.init(userName: name, userAvatar: avatar, ownerID: id))
                }
                DispatchQueue.main.async {
                    complition(fullNamesFriends)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    complition([])
                }
            }
        }
        DispatchQueue.global(qos: .utility).async {
            task.resume()
        }
    }
}

