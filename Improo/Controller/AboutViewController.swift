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
        
        if UserDefaults.standard.bool(forKey: FullAccessID) {
            hidePurchaseInfo()
        } else {
            buyFullAccessButton?.setTitle(PurchaseManager.shared.purchaseButtonTitle, for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AboutViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: PurchaseNotification),
                                               object: nil)
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
            hidePurchaseInfo()
        } else {
            showAlert(title: "Purchase Error", message: productID)
        }
    }
    
    func hidePurchaseInfo() {
        buyFullAccessButton?.removeFromSuperview()
        fullAccessDescriptionLabel?.removeFromSuperview()
        restorePurchasesButton?.removeFromSuperview()
    }
}
