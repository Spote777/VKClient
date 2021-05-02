//
//  NetworkManager.swift
//  VKAccount
//
//  Created by Павел Заруцков on 23.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkManager {
    
    private var urlComponents = URLComponents()
    private let constants = NetworkConstants()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    private let queue = OperationQueue()
    
    init() {
        
        urlComponents.scheme = constants.scheme
        urlComponents.host = constants.host
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func fetchRequestGroupsUser() {
        
        urlComponents.path = "/method/groups.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        let getDataOperation = GetDataOperation(urlRequest: urlComponents.url!)
        queue.addOperation(getDataOperation)
        
        let parseDataOperation = ParseDataOperation()
        parseDataOperation.addDependency(getDataOperation)
        queue.addOperation(parseDataOperation)
        
        let savingDataOperation = SavingDataOperation()
        savingDataOperation.addDependency(parseDataOperation)
        queue.addOperation(savingDataOperation)
    }
    
    
    func fetchRequestFriends() -> Promise<[Friends]> {
        
        urlComponents.path = "/method/friends.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "photo_100"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        let promise = Promise<[Friends]> { [weak self] resolver in
            
            session.dataTask(with: urlComponents.url!) { (data, response, error) in
                
                guard let data = data else {
                    resolver.reject(error!)
                    return
                }
                
                do {
                    
                    let decoder = JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let friends = try? decoder.decode(VKResponse<Friends>.self, from: data).items else {
                        resolver.reject(error!)
                        return
                    }
                    
                    resolver.fulfill(friends)
                    
                } catch {
                    resolver.reject(error)
                }
            }.resume()
        }
        return promise
    }
}
