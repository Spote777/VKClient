//
//  GetPhotoFriends.swift
//  VKAccount
//
//  Created by Павел Заруцков on 09.02.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation

class GetPhotosFriend {
    
    func loadData(owner_id: String, complition: @escaping ([String]) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.getAll"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: owner_id),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let arrayPhotosFriend = try JSONDecoder().decode(PhotosResponse.self, from: data)
                var photosFriend: [String] = []
                
                for i in 0...arrayPhotosFriend.response.items.count-1 {
                    if let urlPhoto = arrayPhotosFriend.response.items[i].sizes.last?.url {
                        photosFriend.append(urlPhoto)
                    }
                }
                DispatchQueue.main.async {
                    complition(photosFriend)
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
