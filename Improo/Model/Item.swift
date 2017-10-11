//
//  Item.swift
//  Improo
//
//  Created by 3axap on 24.01.17.
//  Copyright © 2017 3axap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Item {
    //var id: String
    var title: String = ""
    var description: String = ""
    var categories: [String] = []
    var imageURL: URL?
    var url: URL?
    var author: String?
    
    init?(dictionary: [String:Any]) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String else {
                return nil
        }
        self.title = title
        self.description = description
        
        if let categories = dictionary["categories"] as? [String] {
            self.categories = categories
        }
        
        if let urlString = dictionary["url"] as? String, let url = URL(string: urlString) {
            self.url = url
        }
        
        if let imageURLString = dictionary["imageUrl"] as? String, let imageURL = URL(string: imageURLString) {
            self.imageURL = imageURL
        }
        
        if let author = dictionary["author"] as? String {
            self.author = author
        }
    }
}
