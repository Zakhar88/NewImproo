//
//  ItemViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 10.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class ItemViewController: AdvertisementViewController {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var authorLabel: UILabel?
    @IBOutlet weak var categoriesLabel: UILabel?
    @IBOutlet weak var imageView: ImprooImageView?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var openURLBarButton: UIBarButtonItem?
    
    var selectedItem: Item? {
        didSet {
            guard let selectedItem = selectedItem else { return }
            loadViewIfNeeded()
            titleLabel?.text = selectedItem.title
            
            descriptionTextView?.text = "\t" + selectedItem.description.replacingOccurrences(of: "\n", with: "\n\t")
            
            authorLabel?.text = selectedItem.author
            categoriesLabel?.text = selectedItem.categories.joined(separator: ", ")
            
            if let image = selectedItem.image, image != UIImage(named: selectedItem.section.rawValue + "Stub") {
                self.imageView?.fit(toImage: image, borderWidth: 2)
            } else {
                self.imageView?.superview?.removeFromSuperview()
            }
            
            if let url = selectedItem.url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true), let hostName = urlComponents.host {
                openURLBarButton?.title = hostName
            } else {
                openURLBarButton?.title = "Google"
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
        let url: URL
        //TODO: Update with switch item.section
        if let itemUrl = selectedItem.url {
            url = itemUrl
        } else if let author = selectedItem.author, let bookURL = getGoogleSearchURL(parameters: "\(selectedItem.title) \(author)") {
            url = bookURL
        } else if let itemURL = getGoogleSearchURL(parameters: "\(selectedItem.title)") {
            url = itemURL
        } else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    func getGoogleSearchURL(parameters: String) -> URL? {
        let scheme = "https"
        let host = "www.google.com"
        let path = "/search"
        let value = parameters.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
        let queryItem = URLQueryItem(name: "q", value: value)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        return urlComponents.url
    }
}
