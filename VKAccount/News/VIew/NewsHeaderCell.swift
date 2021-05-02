//
//  NewsHeaderCell.swift
//  VKAccount
//
//  Created by Павел Заруцков on 12.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

class NewsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
        
    func configureUser(item: NewsFeed) {
        author.text = item.creatorName
        
        DispatchQueue.global().async {
            guard let url = item.avatarUrl,
                  let imageURL = URL(string: url),
                  let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.avatar.image = UIImage(data: imageData)
            }
        }
        
    }
}
