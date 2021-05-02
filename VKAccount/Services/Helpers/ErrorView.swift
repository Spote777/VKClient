//
//  ErrorView.swift
//  VKAccount
//
//  Created by Павел Заруцков on 07.02.2021.
//  Copyright © 2021 Павел. All rights reserved.
//

import UIKit

class ErrorView {
    public func showErrorAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        // Показываем UIAlertController
//        present(alert, animated: true, completion: nil)
    }
}
