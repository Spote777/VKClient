//
//  VKService.swift
//  VKAccount
//
//  Created by Павел Заруцков on 27.11.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation
import RealmSwift

final class VKService {
    
    let session = Session.instance.token
    let realmManager = RealmManager()
    
    enum ApiMethod {
        case groups
        case searchGroups(searchText:String)
        case postNews(nextFeed: String)
        
        var path: String {
            switch self {
            case .groups:
                return "/method/groups.get"
            case .searchGroups:
                return "/method/groups.search"
            case .postNews:
                return "/method/newsfeed.get"
            }
        }
        var parameters: [String: String] {
            switch self {
            case .groups:
                return ["extended":"1"]
            case let .searchGroups(searchText):
                return ["q": searchText]
            case let .postNews(nextFeed):
                return ["filters":"post, wall_photo",
                        "start_from":nextFeed]
            }
        }
    }
    
    private func request(_ method: ApiMethod,
                         completion: @escaping (Data?) -> Void) {
        var componets = URLComponents()
        componets.scheme = "https"
        componets.host = "api.vk.com"
        componets.path = method.path
        let defaultQueryItems = [
            URLQueryItem(name: "access_token", value: session),
            URLQueryItem(name: "v", value: "5.126")
        ]
        let maethodQueryItems = method.parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        componets.queryItems = defaultQueryItems + maethodQueryItems
        
        guard let url = componets.url else {
            completion(nil)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        DispatchQueue.global(qos: .utility).async {
            task.resume()
        }
    }
    
    func getGroups(completion: @escaping ([Groups]) -> Void) {
        request(.groups) { (data) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(VKResponse<Groups>.self,
                                                        from: data)
                
                self.realmManager.saveToRealm(response.items)
                completion(response.items)
            } catch {
                print(error)
            }
        }
    }
    
    func searchGroup(searchText: String, completion: @escaping ([Groups]) -> Void) {
        request(.searchGroups(searchText: searchText)) { (data) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(VKResponse<Groups>.self,
                                                        from: data)
                completion(response.items)
            } catch {
                print(error)
            }
        }
    }
    
    func getNewsFeed(nextFeed: String = "", completion: @escaping ([NewsFeed], String) -> Void) {
        request(.postNews(nextFeed: nextFeed)) { (data) in
            guard let data = data else { return }
            do {
                JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
                
                var newsFeed = try JSONDecoder().decode(NewsFeedResponse.self,
                                                        from: data).response.items
                let groups = try JSONDecoder().decode(NewsFeedResponse.self,
                                                      from: data).response.groups
                let users = try JSONDecoder().decode(NewsFeedResponse.self,
                                                     from: data).response.profiles
                let nextFeed = try JSONDecoder().decode(NewsFeedResponse.self,
                                                        from: data).response.next_from
                
                for i in 0..<newsFeed.count {
                    if newsFeed[i].sourceID < 0 {
                        let group = groups?.first(where: { $0.id == -newsFeed[i].sourceID })
                        newsFeed[i].avatarUrl = group?.photo_100
                        newsFeed[i].creatorName = group?.name
                    } else {
                        let profile = users?.first(where: { $0.id == newsFeed[i].sourceID })
                        newsFeed[i].avatarUrl = profile?.photo_100
                        newsFeed[i].creatorName = profile?.fullName
                    }
                }
                completion(newsFeed, nextFeed)
                
            } catch {
                print(error)
            }
        }
    }
}

