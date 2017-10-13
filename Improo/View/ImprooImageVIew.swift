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
        
        prepareImageView(self)
    }
    
    func prepareImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
    }
    
    @objc func showFullscreenImage() {
        fullscreenImageView = UIImageView(image: image)
        fullscreenImageView.contentMode = .scaleAspectFit
        fullscreenImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        fullscreenImageView.alpha = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideFullscreenImage))
        fullscreenImageView.isUserInteractionEnabled = true
        fullscreenImageView.addGestureRecognizer(tapGestureRecognizer)
        
        prepareImageView(fullscreenImageView)
        
        let topWindow = UIApplication.shared.windows.first!
        fullscreenImageView.frame = self.convert(frame, to: topWindow)
        topWindow.addSubview(fullscreenImageView)
        fullscreenImageView.translatesAutoresizingMaskIntoConstraints = false
        fullscreenImageView.centerXAnchor.constraint(equalTo: topWindow.centerXAnchor).isActive = true
        fullscreenImageView.centerYAnchor.constraint(equalTo: topWindow.centerYAnchor).isActive = true

        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.fullscreenImageView.frame = CGRect(origin: CGPoint.zero, size: self.fullscreenImageView.image!.size)
            self.fullscreenImageView.alpha = 1
            self.fullscreenImageView.layoutSubviews()
        }, completion: nil)
    }
    
    @objc func hideFullscreenImage() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.fullscreenImageView.frame = self.convert(self.frame, to: UIApplication.shared.windows.first!)
            self.fullscreenImageView.alpha = 0
        }, completion: { finished in
            self.fullscreenImageView.removeFromSuperview()
            self.fullscreenImageView = nil
        })
    }
}
