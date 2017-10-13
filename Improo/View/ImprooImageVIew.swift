//
//  ImprooImageVIew.swift
//  Improo
//
//  Created by Zakhar Garan on 13.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class ImprooImageView: UIImageView {
    var fullscreenImageView: UIImageView!
    
    override var image: UIImage? {
        didSet {
            super.image = image
            setup()
        }
    }
    
    func setup() {
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showFullscreenImage))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        addBorder(self)
    }
    
    func addBorder(_ imageView: UIImageView, width: CGFloat = 2) {
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth =  width
    }
    
    @objc func showFullscreenImage() {
        fullscreenImageView = UIImageView(image: image)
        fullscreenImageView.contentMode = .scaleAspectFit
        fullscreenImageView.alpha = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideFullscreenImage))
        fullscreenImageView.isUserInteractionEnabled = true
        fullscreenImageView.addGestureRecognizer(tapGestureRecognizer)
        
        addBorder(fullscreenImageView, width: 5)
        
        let topWindow = UIApplication.shared.windows.first!
        let backgroundView = UIView(frame: self.convert(frame, to: topWindow))
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundView.alpha = 0
        fullscreenImageView.frame = self.convert(frame, to: topWindow)
        fullscreenImageView.center = backgroundView.center
        backgroundView.addSubview(fullscreenImageView)
        topWindow.addSubview(backgroundView)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.fullscreenImageView.frame = CGRect(origin: CGPoint.zero, size: self.fullscreenImageView.image!.size)
            self.fullscreenImageView.center = topWindow.center
            self.fullscreenImageView.alpha = 1
            backgroundView.frame = topWindow.frame
            backgroundView.center = topWindow.center
            backgroundView.alpha = 1
        }, completion: nil)
    }
    
    @objc func hideFullscreenImage() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            let newFrame = self.convert(self.frame, to: UIApplication.shared.windows.first!)
            self.fullscreenImageView.superview?.frame = newFrame
            self.fullscreenImageView.superview?.alpha = 0
            self.fullscreenImageView.frame = newFrame
            self.fullscreenImageView.alpha = 0
        }, completion: { finished in
            self.fullscreenImageView.superview?.removeFromSuperview()
            self.fullscreenImageView = nil
        })
    }
}
