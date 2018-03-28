//
//  Settings.swift
//  Improo
//
//  Created by Zakhar Garan on 22.03.18.
//  Copyright © 2018 GaranZZ. All rights reserved.
//

import Foundation
import Firebase

class Settings {
    var sections: [Section] = []
    var showAdvertisement: Bool = false
    
    init() {
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        
        if let showAdvertisement = documentSnapshot.data()?["showAdvertisement"] as? Bool {
            self.showAdvertisement = showAdvertisement
        }
        
        if let activeSections = documentSnapshot.data()?["activeSections"] as? [String] {
            for section in activeSections {
                if let activeSection = Section(rawValue: section) {
                    sections.append(activeSection)
                }
            }
        }
    }
}
