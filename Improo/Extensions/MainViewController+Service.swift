//
//  MainViewController+Service.swift
//  Improo
//
//  Created by Zakhar Garan on 11.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Foundation
import Firebase

extension MainViewController {
    
    func addTestBooks() {
        addBook(title: "«Поштовх. Як допомогти людям зробити правильний вибір»", description: "Приймати рішення — це наче шукати потрібні двері у закручених коридорах багатоповерхового будинку. Тому й не дивно, що ми часто опиняємося не там, де хотіли б.\nЩоб вирішити цю проблему, Талер і Санстейн пропонують концепцію поштовхів, або наджів. Це м’який спосіб вплинути на вибір людини, не вдаючись до маніпуляцій, заборон чи наказів. З їхньою допомогою можна сприяти розумним покупкам та інвестиціям, економії електроенергії, безпеці на дорозі, вживанню здорової їжі та багатьом іншим корисним речам. Тобто підштовхнути людину до «правильних» дверей, зберігаючи свободу вибору кожного.", author: "Річард Талер, Кас Санстейн", categories: [Category.psychology.rawValue, Category.economy.rawValue, Category.sociology.rawValue], imageURL: "https://nashformat.ua/files/products/poshtovkh-yak-dopomohty-liudiam-zrobyty-pravylnyi-vybir-709043.400x500w.jpeg")
    }
    
    func addBook(title: String, description: String, author: String, categories: [String], imageURL: String?) {
        var bookDocument: [String: Any] = ["title": title, "description": description, "author": author, "categories": categories]
        if let imageURL = imageURL {
            bookDocument["imageUrl"] = imageURL
        }
        databaseReference.collection("ukrainian/Books/Collection").addDocument(data: bookDocument) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add book", message: error.localizedDescription)
                }
            }
        }
    }
    
    func addBooksCategories() {
        let categories = ["Бізнес", "Економіка", "Кар'єра", "Мотивація", "Психологія", "Розвиток", "Соціологія", "Спорт", "Стосунки", "Філософія", "Харчування", "Художні"]
        let categoriesField = ["Categories": categories]
        databaseReference.document("ukrainian/Books").setData(categoriesField) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add categories", message: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        navigationController?.present(alertViewController, animated: true)
    }
}