//
//  UIImageView + Helpers.swift
//  Improo
//
//  Created by 3axap on 23.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func fit(toImage image: UIImage, borderWidth: CGFloat? = nil ) {
        let aspectRatioConstraintIdentifier = "aspectRatioConstraint"
        
        self.image = image
        for constraint in constraints {
            if constraint.identifier == aspectRatioConstraintIdentifier {
                removeConstraint(constraint)
                break
            }
        }
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: image.size.height/image.size.width, constant: 0)
        aspectRatioConstraint.identifier = aspectRatioConstraintIdentifier
        self.addConstraint(aspectRatioConstraint)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.isHidden = false
            self.alpha = 1
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            if let borderWidth = borderWidth {
                self.addBorder(width: borderWidth)
            }
        })
    }
}
