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
    @IBOutlet weak var turnOffAdvertisementButton: UIButton?
    @IBOutlet weak var sendFeedbackButton: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aboutTextView?.text = FirestoreManager.shared.infoText
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UserDefaults.standard.bool(forKey: hideAdvertisementUserDefauleSettingKey) {
            turnOffAdvertisementButton?.removeFromSuperview()
        }
    }
}
