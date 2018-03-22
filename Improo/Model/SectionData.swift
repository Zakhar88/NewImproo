//
//  SectionData.swift
//  Improo
//
//  Created by Zakhar Garan on 22.03.18.
//  Copyright © 2018 GaranZZ. All rights reserved.
//

import Foundation

class SectionData {
    var section: Section
    var items: [Item]
    var categories = [String]()
    
    init(section: Section, items: [Item]) {
        self.section = section
        self.items = items
    }
}
