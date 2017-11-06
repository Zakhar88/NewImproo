//
//  ItemCollectionViewCell.swift
//  Improo
//
//  Created by Zakhar Garan on 05.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import FirebaseStorage

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var imageDownloadTask: StorageDownloadTask?
    
    var item: Item! {
        didSet {
            imageDownloadTask?.cancel()
            imageDownloadTask = nil
            
            layoutIfNeeded()
            titleLabel.text = item.title
            detailsLabel.text = item.author ?? item.categories.joined(separator: ", ")
            coverImageView.isHidden = true
            coverImageView.alpha = 0
            
            if let image = item.image {
                coverImageView.fit(toImage: image, borderWidth: 1)
            } else {
                loadImage()
            }
        }
    }
    
    private func setEmptyImage() {
        guard let image = UIImage(named: "stub.png") else { return }
        coverImageView.fit(toImage: image)
        coverImageView.layer.borderWidth = 0
    }
    
    private func loadImage() {
        let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imageURL = item.section.rawValue + "/" + item.id + ".jpeg"
        guard let imagePath = documentsFolderURL?.appendingPathComponent(imageURL) else {
            setEmptyImage()
            return
        }
        if !setLocalImage(imageUrl: imagePath) {
            guard let folderPath = documentsFolderURL?.appendingPathComponent(item.section.rawValue).path, directoryExists(forPath: folderPath) else {
                setEmptyImage()
                return
            }
            let imageReference = Storage.storage().reference(withPath: imageURL)
            imageDownloadTask = imageReference.write(toFile: imagePath, completion: { (url, error) in
                guard let url = url else {
                    self.setEmptyImage()
                    return
                }
                DispatchQueue.main.async { _ = self.setLocalImage(imageUrl: url) }
            })
        }
    }
    
    private func setLocalImage(imageUrl: URL) -> Bool {
        guard let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) else { return false }
        item.image = image
        coverImageView.fit(toImage: image, borderWidth: 1)
        return true
    }
    
    private func directoryExists(forPath sectionPath: String) -> Bool {        
        if FileManager.default.fileExists(atPath: sectionPath) {
            return true
        } else {
            do {
                try FileManager.default.createDirectory(atPath: sectionPath, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                FirestoreManager.shared.uploadError(error)
                return false
            }
        }
    }
}
