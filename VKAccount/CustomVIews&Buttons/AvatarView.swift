//
//  Avatar.swift
//  VKAccount
//
//  Created by Заруцков Павел on 21.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

@IBDesignable class AvatarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tapOnButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tapOnButton()
    }
    
    func tapOnButton() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func onTap(gestureRecognizer: UITapGestureRecognizer) {
        let original = self.transform
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.1, options: [ .autoreverse], animations: {
                        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.transform = original
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(avatarSettings.cornerRadius)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0
    }
}
