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
    
    var selectedItem: Item? {
        didSet {
            guard let selectedItem = selectedItem else { return }
            loadViewIfNeeded()
            titleLabel?.text = selectedItem.title
            descriptionTextView?.text = "   " + selectedItem.description.replacingOccurrences(of: "\n", with: "\n   ")
            if let selectedBook = selectedItem as? Book {
                authorLabel?.text = selectedBook.author
            } else {
                authorLabel?.removeFromSuperview()
            }
            if let imageURL = selectedItem.imageURL {
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: imageURL) else {
                        DispatchQueue.main.async { self.imageView?.superview?.removeFromSuperview() }
                        return
                    }
                    DispatchQueue.main.async { self.imageView?.image = UIImage(data: data) }
                }
            } else {
                self.imageView?.superview?.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(back))
        backGestureRecognizer.direction = .right
        view.addGestureRecognizer(backGestureRecognizer)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openURL() {
        guard let selectedItem = selectedItem else { return }
        let url: URL?
        
        if let itemUrl = selectedItem.url {
            url = itemUrl
        } else {
            let scheme = "https"
            let host = "www.google.com"
            let path = "/search"
            let value: String
            
            if let book = selectedItem as? Book {
                value = "\(book.title.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")) \(book.author)"
            } else {
                value = selectedItem.title
            }
            
            let queryItem = URLQueryItem(name: "q", value: value)
            
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = [queryItem]
            url = urlComponents.url
        }
        if let url = url {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
