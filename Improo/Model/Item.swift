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
    var title: String
    let description: String
    let categories: [String]
    var imageURL: URL?
    var url: URL?
    
    init?(dataSnapshot: DataSnapshot) {
        guard let value = dataSnapshot.value as? NSDictionary,
            let newTitle = value["title"] as? String,
            let newDescription = value["description"] as? String,
            let newCategories = value["categories"] as? [String] else {
                return nil
        }
        title = newTitle
        description = newDescription
        categories = newCategories
        
        if let newURLString = value["url"] as? String, let newURL = URL(string: newURLString) {
            url = newURL
        }
        
        if let imageURLString = value["imageurl"] as? String, let imageNewURL = URL(string: imageURLString) {
            imageURL = imageNewURL
        }
    }
    
    init() {
        title = "Test Title"
        description = "Test Description"
        categories = ["TestCat1", "TestCat2"]
        url = URL(string: "https://www.facebook.com")
    }
    
    convenience init(name: String) {
        self.init()
        title = name
    }
    
    func getImage() -> UIImage {
        return UIImage(named: "TestImage")!

    }
}
