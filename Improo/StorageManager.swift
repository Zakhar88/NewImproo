//
//  StorageManager.swift
//  Improo
//
//  Created by Zakhar Garan on 20.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    static func loadImages() {
        let imageReference = Storage.storage().reference().b
        imageReference.getMetadata { (metaData, error) in
            print(metaData?.downloadURLs)
        }
    }
}
