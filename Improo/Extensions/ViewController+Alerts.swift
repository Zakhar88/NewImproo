//
//  ViewController+Alerts.swift
//  Improo
//
//  Created by Zakhar Garan on 19.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        navigationController?.present(alertViewController, animated: true)
    }
    
    func showError(_ error: Error?) {
        showAlert(title: "Error", message: error?.localizedDescription)
    }
}
