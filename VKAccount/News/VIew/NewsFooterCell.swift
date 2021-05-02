//
//  NewsFooterCell.swift
//  VKAccount
//
//  Created by Павел Заруцков on 12.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

class NewsFooterCell: UITableViewCell {

    @IBOutlet weak var likeControl: LikeControl!
    @IBOutlet weak var allViewCount: UILabel!
    
    func configure(item: NewsFeed) {
        self.likeControl.setLike(count: item.likes?.count ?? 0)
        self.allViewCount.text = "\(item.views?.count ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        likeControl.setLike(count: 0)
        allViewCount.text = nil
    }
}
