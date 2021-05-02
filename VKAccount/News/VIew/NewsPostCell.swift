//
//  NewsPostCell.swift
//  VKAccount
//
//  Created by Павел Заруцков on 12.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

protocol NewsPostCellDelegate: class {
    func didTappedShowMore(_ cell: NewsPostCell)
}

class NewsPostCell: UITableViewCell {
    
    weak var delegate: NewsPostCellDelegate?
    
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postStackView: UIStackView!
    
    var isExpanded = false {
        didSet {
            updatePostLabel()
            updateShowMoreButton()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePost.image = nil        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatePostLabel()
        updateShowMoreButton()
    }
    
    func configure(item: NewsFeed) {
        post.text = item.text
        if let imgUrl = URL(string: item.photosUrl?.last ?? "") {
            imagePost.load(url: imgUrl)
        }
    }
    
    @IBAction func showMoreButtonTapped(_ sender: UIButton) {
        delegate?.didTappedShowMore(self)
    }
    
    func updatePostLabel() {
        post.numberOfLines = isExpanded ? 0 : 3
    }
    
    func updateShowMoreButton() {
        let title = isExpanded ? "Show less..." : "Show more..."
        showMore.setTitle(title, for: .normal)
    }
}
