//
//  Categories.swift
//  Improo
//
//  Created by Zakhar Garan on 11.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation

enum Category: String {
    case business = "Бізнес"
    case economy = "Економіка"
    case career = "Кар'єра"
    case motivation = "Мотивація"
    case politics = "Політика"
    case psychology = "Психологія"
    case progress = "Розвиток"
    case sociology = "Соціологія"
    case sport = "Спорт"
    case relationships = "Стосунки"
    case phylosophy = "Філософія"
    case nutrition = "Харчування"
    case artistic = "Художні"
    case lifeMeaning = "Сенс життя"
    
    var all: [String] {
        return ["Бізнес", "Економіка", "Кар'єра", "Мотивація", "Політика", "Психологія", "Розвиток", "Соціологія", "Спорт", "Стосунки", "Філософія", "Харчування", "Художні", "Сенс життя"]
    }
}
