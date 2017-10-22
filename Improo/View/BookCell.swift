//
//  BookCell.swift
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
            titleLabel?.text = book.title
            detailsLabel?.text = book.author
        }
    }
    
    func showImage() {        
        if let image = book.image {
            coverImageView.image = image
        } else if let imageName = book.imageName {
            let storage = Storage.storage()
            let imageReference = storage.reference().child("Books").child(imageName)
            imageReference.getData(maxSize: 1*1024*1024, completion: { (data, error) in
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async{ self.coverImageView.superview?.removeFromSuperview() }
                    return
                }
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                    self.book.image = image
                    UIView.animate(withDuration: 0.5, animations: {
                        self.coverImageView.addConstraint(NSLayoutConstraint(item: self.coverImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.coverImageView, attribute: NSLayoutAttribute.width, multiplier: image.size.height/image.size.width, constant: 0))
                        self.coverImageView.isHidden = false
                        self.coverImageView.alpha = 1
                        self.coverImageView.addBorder(width: 1)
                    })
                }
            })
        } else {
            self.coverImageView.superview?.removeFromSuperview()
        }
    }
}
