//
//  MainViewController+Purchase.swift
//  Improo
//
//  Created by Zakhar Garan on 04.01.18.
//  Copyright © 2018 GaranZZ. All rights reserved.
//

import Foundation

extension MainViewController {
    
    @IBAction func buyFullAccess() {
        PurchaseManager.shared.buyProVersion()
    }
    
    @IBAction func restorePurchases() {
        PurchaseManager.shared.restorePurchases()
    }
    
    
}
