//
//  UIimage URL.swift
//  VKAccount
//
//  Created by Павел Заруцков on 30.11.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

extension UIImageView {
    func downlaodImage(urlPath: String?) {
        guard let urlPath = urlPath, let url = URL(string: urlPath) else {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
