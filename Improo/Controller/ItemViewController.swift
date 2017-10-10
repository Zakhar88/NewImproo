//
//  ItemViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 10.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var authorLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var openItemURLButton: UIButton?
    
    var selectedItem: Item? {
        didSet {
            guard let selectedItem = selectedItem else { return }
            loadViewIfNeeded()
            titleLabel?.text = selectedItem.title
            descriptionTextView?.text = selectedItem.description
            if let authorTitle = selectedItem.author {
                authorLabel?.text = authorTitle
            } else {
                authorLabel?.removeFromSuperview()
            }
            if let imageURL = selectedItem.imageURL {
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: imageURL) else {
                        self.imageView?.removeFromSuperview()
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data: data)
                    }
                }
            } else {
                imageView?.removeFromSuperview()
            }
        }
    }
}
