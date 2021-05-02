//
//  ExtentionTableVIew.swift
//  VKAccount
//
//  Created by Павел Заруцков on 31.01.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

extension UITableView {
    
    func showEmptyMessage(_ message: String) {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.text = message
        self.backgroundView = label
    }
    
    func hideEmptyMessage() {
        self.backgroundView = nil
    }
}
