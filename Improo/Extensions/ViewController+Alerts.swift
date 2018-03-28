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
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        navigationController?.present(alertViewController, animated: true)
    }
    
    func showError(_ error: Error?) {
        guard let error = error else { return }
        showAlert(title: "Error", message: error.localizedDescription)
        FirestoreManager.shared.uploadError(error)
    }
}

