//
//  AboutView.swift
//  Improo
//
//  Created by Zakhar Garan on 18.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class AboutView: UIView {

    @IBOutlet weak var infoTextLabel: UILabel?
    @IBOutlet weak var nicknameField: UITextField? {
        didSet {
            nicknameField?.addBorder(width: 1, color: UIColor.lightGray)
        }
    }
    @IBOutlet weak var messageTextView: UITextView? {
        didSet {
            messageTextView?.addBorder(width: 1, color: UIColor.lightGray)
        }
    }
    @IBOutlet weak var sendButton: UIButton? {
        didSet {
            sendButton?.layer.cornerRadius = 5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @IBAction func sendMessage() {
        guard let message = messageTextView?.text, !message.isEmpty else { return }
        FirestoreManager.shared.uploadMessage(messageText: message, nickname: nicknameField?.text) { error in
            guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let topViewController = navigationController.visibleViewController as? AdvertisementViewController else { return }
            if let error = error {
                topViewController.showError(error)
            } else {
                self.messageTextView?.text = ""
                self.enableSendButton(false)
                topViewController.showAlert(title: "Надіслано!", message: "Дякуємо за відгук!")
            }
        }
    }
    
    func enableSendButton(_ enabled: Bool) {
        sendButton?.isEnabled = enabled
        sendButton?.backgroundColor = enabled ? sendButton?.tintColor : UIColor.lightGray
    }
    
    
}

extension AboutView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        enableSendButton(!textView.text.isEmpty)
    }
}
