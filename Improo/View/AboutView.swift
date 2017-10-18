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
        //TODO: write message to Firestore
    }
    
    
}

extension AboutView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton?.isEnabled = !textView.text.isEmpty
        sendButton?.backgroundColor = textView.text.isEmpty ? UIColor.lightGray : sendButton?.tintColor
    }
}
