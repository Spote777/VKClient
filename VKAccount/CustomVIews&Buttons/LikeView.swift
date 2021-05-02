//
//  LikeView.swift
//  VKAccount
//
//  Created by Заруцков Павел on 23.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    var countLikes = 0
    var userLiked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLikeControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLikeControl()
    }

    func setLike(count: Int){
        countLikes = count
        setupLikeControl()
    }
    
    @IBInspectable var colorNoLike: UIColor = UIColor.opaqueSeparator {
        didSet {
            likeImgView.tintColor = colorNoLike
            labelLikes.textColor = colorNoLike
        }
    }
    @IBInspectable var colorYesLike: UIColor = UIColor.red
    
    let likeImgView = UIImageView(image: UIImage(systemName: "heart"))
    let labelLikes = UILabel()
    
    func setupLikeControl() {
     
        likeImgView.tintColor = colorNoLike
        likeImgView.layer.frame = CGRect(x: 0, y: 3, width: 24.3, height: 19.8)
        
        labelLikes.text = String(countLikes)
        labelLikes.textColor = colorNoLike
        labelLikes.font = .systemFont(ofSize: 18)
        labelLikes.frame = CGRect(x: 30 , y: 2, width: 40, height: 20)
        
        self.addSubview(likeImgView)
        self.addSubview(labelLikes)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let original = self.likeImgView.transform
        UIView.animate(withDuration: 0.1, delay: 0, options: [ .autoreverse], animations: {
            self.likeImgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            self.likeImgView.transform = original
        })
        
        if userLiked {
            userLiked = false
            countLikes -= 1
            labelLikes.text = String(countLikes)
            labelLikes.textColor = colorNoLike
            likeImgView.tintColor = colorNoLike
            likeImgView.image =  UIImage(systemName: "heart")
        } else {
            userLiked = true
            countLikes += 1
            labelLikes.text = String(countLikes)
            labelLikes.textColor = colorYesLike
            likeImgView.tintColor = colorYesLike
            likeImgView.image =  UIImage(systemName: "heart.fill")
        }
        return false
    }
}
