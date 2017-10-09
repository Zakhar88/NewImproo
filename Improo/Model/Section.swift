//
//  Section.swift
//  Improo
//
//  Created by Zakhar Garan on 04.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

enum Section: String {
    case Activities = "Activities"
    case Books = "Books"
    case Courses = "Courses"
    case Entertainment = "Entertainment"
    case Food = "Food"
    
    init?(ukrainianTitle: String?) {
        guard let title = ukrainianTitle else { return nil }
        switch title {
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
