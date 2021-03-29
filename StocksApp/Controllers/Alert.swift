//
//  Alert.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 26.03.2021.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
