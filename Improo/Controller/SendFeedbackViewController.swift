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
    @IBOutlet weak var nicknameField: UITextField?
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var messageTextViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageTextView?.placeholder = "Ваше повідомлення..."
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
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
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        messageTextViewBottomConstraint?.constant = keyboardFrame.size.height + 16.0
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        messageTextViewBottomConstraint?.constant = 16.0
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
