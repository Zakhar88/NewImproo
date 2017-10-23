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
    
    var item: Item! {
        didSet {
            layoutIfNeeded()
            titleLabel?.text = item.title
            detailsLabel?.text = item.author
            tryToDisplayImage()
        }
    }
    
    func tryToDisplayImage() {
        if let image = item.image {
            coverImageView.image = image
            fitCoverImageView(imageSize: image.size)
        } else {
            StorageManager.getImage(forSection: item.section, imageName: item.id + ".jpeg", completion: { (image) in
                DispatchQueue.main.async {
                    guard let image = image ?? UIImage(named: "bookStub") else {
                        self.hideCoverImageView()
                        return
                    }
                    self.item.image = image
                    self.coverImageView.image = image
                    self.fitCoverImageView(imageSize: image.size)
                }
            })
        }
    }
    
    func fitCoverImageView(imageSize: CGSize) {
        UIView.animate(withDuration: 0.5, animations: {
            let aspectRatioConstraint = NSLayoutConstraint(item: self.coverImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.coverImageView, attribute: NSLayoutAttribute.width, multiplier: imageSize.height/imageSize.width, constant: 0)
            aspectRatioConstraint.identifier = "aspectRatioConstraint"
            self.coverImageView.addConstraint(aspectRatioConstraint)
            self.coverImageView.isHidden = false
            self.coverImageView.alpha = 1
            self.coverImageView.addBorder(width: 1)
        })
    }
    
    func hideCoverImageView() {
        self.coverImageView.isHidden = true
        self.coverImageView.alpha = 0
        for constraint in coverImageView.constraints {
            print(constraint)
            if constraint.identifier == "aspectRatioConstraint" {
                coverImageView.removeConstraint(constraint)
            }
        }
        self.coverImageView.superview?.removeFromSuperview()
    }
}
