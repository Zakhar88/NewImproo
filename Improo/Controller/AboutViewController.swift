//
//  AboutViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 06.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView? {
        didSet {
            //aboutTextView?.addBorder(width: 1, color: UIColor.lightGray)
            FirestoreManager.shared.loadInfo { (infoText, error) in
                guard let infoText = infoText else {
                    self.showError(error)
                    return
                }
                self.aboutTextView?.text = infoText
            }
        }
    }
    
    @IBOutlet weak var turnOffAdvertisementButton: UIButton? {
        didSet {
            turnOffAdvertisementButton?.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var sendFeedbackButton: UIButton? {
        didSet {
            sendFeedbackButton?.layer.cornerRadius = 5
        }
    }
}
