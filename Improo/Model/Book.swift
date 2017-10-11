//
//  Book.swift
//  Improo
//
//  Created by Zakhar Garan on 11.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

class Book: Item {
    
    var author: String = ""
    
    override init?(dictionary: [String : Any]) {
        super.init(dictionary: dictionary)
        guard let author = dictionary["author"] as? String else { return nil }
        self.author = author
    }
}
