//
//  SendFeedbackViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 06.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController {

    @IBOutlet weak var sendButton: UIBarButtonItem?
    
    @IBOutlet weak var nicknameField: UITextField? {
        didSet {
            nicknameField?.addBorder(width: 1, color: UIColor.lightGray)
        }
    }
    
    @IBOutlet weak var messageTextView: UITextView? {
        didSet {
            messageTextView?.addBorder(width: 1, color: UIColor.lightGray)
            messageTextView?.placeholder = "Ваше повідомлення..."

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendMessage() {
        guard let message = messageTextView?.text, !message.isEmpty else { return }
        FirestoreManager.shared.uploadMessage(messageText: message, nickname: nicknameField?.text) { error in
            if let error = error {
                self.showError(error)
            } else {
                self.messageTextView?.text = ""
                self.enableSendButton(false)
                self.showAlert(title: "Надіслано!", message: "Дякуємо за відгук!")
            }
        }
    }
    
    func enableSendButton(_ enabled: Bool) {
        sendButton?.isEnabled = enabled
        //sendButton?.backgroundColor = enabled ? sendButton?.tintColor : UIColor.lightGray
    }
}

extension SendFeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        enableSendButton(!textView.text.isEmpty)
    }
}
