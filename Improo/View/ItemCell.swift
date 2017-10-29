//
//  ItemCell.swift
//  Improo
//
//  Created by Zakhar Garan on 20.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import FirebaseStorage

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var item: Item! {
        didSet {
            layoutIfNeeded()
            titleLabel.text = item.title
            detailsLabel.text = item.author ?? item.categories.joined(separator: ", ")
            coverImageView.isHidden = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            coverImageView.alpha = 0
            displayImage()
        }
    }
    
    func displayImage() {
        if let image = item.image {
            activityIndicatorView.isHidden = true
            coverImageView.fit(toImage: image)
        } else {
            //TODO: Could be needed to check image extension - jpeg or png
            StorageManager.getImage(forSection: item.section, imageName: item.id + ".jpeg", completion: { (image) in
                DispatchQueue.main.async {
                    self.activityIndicatorView.isHidden = true
                    if let image = image {
                        self.item.image = image
                        self.coverImageView.fit(toImage: image, borderWidth: 1)
                    } else if let stubImage = UIImage(named: self.item.section.rawValue + "Stub"){
                        self.item.image = stubImage
                        self.coverImageView.fit(toImage: stubImage, borderWidth: 0)
                    }
                }
            })
        }
    }
}
