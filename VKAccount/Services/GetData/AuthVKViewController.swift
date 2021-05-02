//
//  AuthVKViewController.swift
//  VKAccount
//
//  Created by Павел Заруцков on 27.11.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit
import WebKit

class AuthVKViewController: UIViewController {
    
    // MARK: - Properties
    
    var session = Session.instance
    
    // MARK: - Outlet
    
    @IBOutlet weak var webView: WKWebView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthVK()
    }
    
    // MARK: - URL Constructor
    
    func loadAuthVK() {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: "7610544"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends, photos, groups, wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        guard let url = urlConstructor.url  else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
}

// MARK: - AuthVKViewControllerExtension

extension AuthVKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // проверка на полученый адрес и получение данных из урла
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        DispatchQueue.main.async {
            
            if let token = params["access_token"], let userID = params["user_id"] {
                self.session.token = token
                self.session.userId = Int(userID)
                decisionHandler(.cancel)
                self.performSegue(withIdentifier: "AuthVKSuccessful", sender: nil)
            } else {
                decisionHandler(.allow)
                self.performSegue(withIdentifier: "AuthVKUnsuccessful", sender: nil)
            }
            
        }
    }
}
