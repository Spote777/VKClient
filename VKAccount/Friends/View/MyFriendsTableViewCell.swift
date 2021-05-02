//
//  MyFriendsTableViewCell.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var photoFriend: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoFriend.image = nil
    }
}
