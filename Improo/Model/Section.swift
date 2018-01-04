//
//  Section.swift
//  Improo
//
//  Created by Zakhar Garan on 04.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

enum Section: String {
    case About = "About"
    case Activities = "Activities"
    case Books = "Books"
    case Courses = "Courses"
    case Entertainment = "Entertainment"
    
    init?(ukrainianTitle: String?) {
        guard let title = ukrainianTitle else { return nil }
        switch title {
            case "Книги":
                self = .Books
            case "Про Нас":
                self = .About
            case "Статті":
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
        case .About:
            return "Про Нас"
        case .Activities:
            return "Статті"
        case .Courses:
            return "Курси"
        case .Entertainment:
            return "Розваги"
        }
    }
}
