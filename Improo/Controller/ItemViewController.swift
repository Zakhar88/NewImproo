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
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var openURLButton: UIButton?
    @IBOutlet weak var googleButton: UIButton?
    @IBOutlet weak var imageBorderView: UIView?
    @IBOutlet weak var separatorView: UIView?
    
    var selectedItem: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(back))
        backGestureRecognizer.direction = .right
        view.addGestureRecognizer(backGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
        setupInfo()
    }
    
    func setupUI() {
        imageBorderView?.layer.borderColor = UIColor.mainThemeColor.cgColor
        imageBorderView?.layer.borderWidth = 2
        separatorView?.backgroundColor = UIColor.mainThemeColor
        openURLButton?.layer.cornerRadius = 5
        googleButton?.layer.cornerRadius = 5
    }
    
    func setupInfo() {
        guard let selectedItem = selectedItem else { return }
        titleLabel?.text = selectedItem.title
        descriptionTextView?.text = "\t" + selectedItem.description.replacingOccurrences(of: "\n", with: "\n\t")
        authorLabel?.text = selectedItem.author
        categoriesLabel?.text = selectedItem.categories.joined(separator: ", ")
        
        if let image = selectedItem.image, image != UIImage(named: selectedItem.section.rawValue + "Stub") {
            self.imageView?.fit(toImage: image)
        } else {
            self.imageView?.superview?.removeFromSuperview()
        }
        
        if let url = selectedItem.url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true), let hostName = urlComponents.host {
            openURLButton?.setTitle(hostName, for: .normal)
        } else {
            openURLButton?.removeFromSuperview()
        }
        
        if selectedItem.section != .Books {
            googleButton?.removeFromSuperview()
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openURL() {
        guard let itemUrl = selectedItem.url else { return }
        UIApplication.shared.open(itemUrl, options: [:])
    }
    
    @IBAction func searchInGoogle() {
        guard let author = selectedItem.author, let searchURL = getGoogleSearchURL(parameters: "\(selectedItem.title) \(author)") else { return }
        UIApplication.shared.open(searchURL, options: [:])
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
