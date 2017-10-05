//
//  Section.swift
//  Improo
//
//  Created by Zakhar Garan on 04.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

enum Section: String {
    case Books = "Books"
    case Food = "Food"
    case Activities = "Activities"
    case Courses = "Courses"
    case Entertainment = "Entertainment"
    
    init?(ukrainianTitle: String) {
        switch ukrainianTitle {
        case "Книги":
            self = .Books
        case "Їжа":
            self = .Food
        case "Дії":
            self = .Activities
        case "Курси":
            self = .Courses
        case "Розваги":
            self = .Entertainment
        default:
            return nil
        }
    }
    
    var ukrainianTitle: String {
        switch self {
        case .Books:
            return "Книги"
        case .Food:
            return "Їжа"
        case .Activities:
            return "Дії"
        case .Courses:
            return "Курси"
        case .Entertainment:
            return "Розваги"
        }
    }
}
