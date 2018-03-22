//
//  Section.swift
//  Improo
//
//  Created by Zakhar Garan on 04.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

enum Section: String {
    case Articles = "Articles"
    case Books = "Books"
    case Courses = "Courses"
    case Entertainment = "Entertainment"
    
    var ukrainianTitle: String {
        switch self {
        case .Books:
            return "Книги"
        case .Articles:
            return "Статті"
        case .Courses:
            return "Курси"
        case .Entertainment:
            return "Розваги"
        }
    }
}
