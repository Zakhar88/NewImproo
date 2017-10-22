//
//  Item.swift
//  Improo
//
//  Created by 3axap on 24.01.17.
//  Copyright © 2017 3axap. All rights reserved.
//

import UIKit

class Item {
    //var id: String
    var title: String = ""
    var description: String = ""
    var categories: [String] = []
    var url: URL?
    var imageName: String?
    var image: UIImage?
    var section: Section
    var author: String?
    
    required init?(dictionary: [String:Any], section: Section) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let categories = dictionary["categories"] as? [String] else {
                return nil
        }
        
        self.title = title
        self.description = description
        self.categories = categories
        
        if let urlString = dictionary["url"] as? String, let url = URL(string: urlString) {
            self.url = url
        }
        
        if let imageName = dictionary["imageName"] as? String {
            self.imageName = imageName
        }
        
        if let author = dictionary["author"] as? String {
            self.author = author
        }
        
        self.section = section
    }
}
