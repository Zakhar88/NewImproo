//
//  AboutViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 06.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView?
    @IBOutlet weak var buyFullAccessButton: UIButton?
    @IBOutlet weak var sendFeedbackButton: UIButton?
    @IBOutlet weak var restorePurchasesButton: UIButton?
    @IBOutlet weak var fullAccessDescriptionLabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aboutTextView?.text = FirestoreManager.shared.infoText
        let title = "Придбати повний доступ ($\(PurchaseManager.shared.fullAccessProduct.price))"
        buyFullAccessButton?.setTitle(title, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AboutViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: PurchaseNotification),
                                               object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UserDefaults.standard.bool(forKey: FullAccessID) {
            buyFullAccessButton?.removeFromSuperview()
            fullAccessDescriptionLabel?.removeFromSuperview()
            restorePurchasesButton?.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func buyFullAccess() {
        PurchaseManager.shared.buyProVersion()
    }
    
    @IBAction func restorePurchases() {
        PurchaseManager.shared.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        if productID == FullAccessID {
            buyFullAccessButton?.removeFromSuperview()
            fullAccessDescriptionLabel?.removeFromSuperview()
        } else {
            showAlert(title: "Purchase Error", message: productID)
        }
    }
}
