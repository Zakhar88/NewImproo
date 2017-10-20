//
//  Book.swift
//  Improo
//
//  Created by Zakhar Garan on 11.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class Book: Item {
    
    var author: String
    var imageName: String?
    
    override init?(dictionary: [String : Any]) {
        guard let author = dictionary["author"] as? String else { return nil }
        self.author = author
        super.init(dictionary: dictionary)
        
        
        if let imageName = dictionary["imageName"] as? String {
            self.imageName = imageName
        }
        
        //            let storage = Storage.storage()
        //            let imageReference = storage.reference().child("Books").child(imageName)
        //            imageReference.getData(maxSize: 1*1024*1024, completion: { (data, error) in
        //                guard error == nil, let data = data, let image = UIImage(data: data) else {
        //                    return
        //                }
        //                self.image = image
        //            })
    }
}
