//
//  StorageManager.swift
//  Improo
//
//  Created by Zakhar Garan on 20.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageManager {
    
    static func getImage(forSection section: Section, imageName: String, completion: (UIImage?, Error?)->()) {
        //TRY LOAD LOCAL IMAG
        //ELSE LOAD FROM SERVER & SAVE LOCAL
        let imageReference = Storage.storage()
    }
}
