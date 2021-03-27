//
//  Alert.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 26.03.2021.
//

import UIKit

struct Alert {
    private static func showBasicAlert(on VC: MainViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        DispatchQueue.main.async {
            VC.present(alert, animated: true)
        }
    }
    
    static func showLimitAlert(on VC: MainViewController) {
        showBasicAlert(on: VC, with: "Title", message: "Reason")
    }
}
