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
    
    func addBusinessMovies() {
        add(section: .Entertainment, title: "27 фильмов, которые должен увидеть каждый предприниматель", description: "Премудростям бізнесу можна вчитися не тільки з книг Річарда Бренсона, але і з художніх фільмів. З цим згодні і самі підприємці, а також лідери думок в уанеті. Слава Баранський, Дмитро Дубілет, Денис Довгополий, Андрій Хорса і інші назвали фільми, які, на їхню думку, повинен побачити кожен підприємець. Нижче ви знайдете повних список з коментарями спікерів про те, чому ці картини навчили їх самих.", categories: ["Бізнес"], url: "https://ain.ua/2015/05/25/27-filmov-kotorye-dolzhen-uvidet-kazhdyj-predprinimatel-rekomenduyut-xorsev-dubilet-dovgopolyj-baranskij-i-drugie")
    }
    
    func addHobbies() {
        add(section: .Articles, title: "5 хобі для вашого розвитку", description: "Щоб запобігти психічному та емоційному вигоранню, людині потрібно \"розбавляти\" свою щоденну рутину. Ось чому кожен із нас повинен мати корисне хобі.\nРоботи ніколи не буває достатньо. Тому кожна людина повинна мати хобі, яке б підвищувало цінність її життя.\nВажливо чимось займатись, тому що в такий спосіб ви підтримуєте баланс між роботою та повсякденним життям. Однак, варто зазначити, що не всі хобі рівнозначні. Тому, замість того, щоб витрачати час на хобі, яке не сприяє вашому благополуччю, інвестуйте час в діяльність, яка підвищить вашу продуктивність. Відшукайте заняття, яке надихатиме вас та робитиме розумнішими.", categories: ["Хобі", "Спорт", "Читання"], url: "https://mizky.com/article/73/5-khobi-dlya-vashoho-rozvytku")
    }
    
    func add(section: Section, title: String, description: String, categories: [String], url: String) {
        let course: [String: Any] = ["title": title, "description": description, "categories": categories, "url": url]
        
        Firestore.firestore().collection("ukrainian/\(section.rawValue)/Collection").addDocument(data: course) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add \(section.rawValue)", message: error.localizedDescription)
                }
            }
        }
    }
    
    func addCS50() {
        addCourse(title: "Основи програмування CS50", description: "Якщо ви давно мріяли навчитися програмувати – цей курс створений саме для вас! Курс CS50 Гарвардського університету вважається найкращим курсом з основ програмування в світі і відтепер він буде доступний українською мовою. Про його легендарний статус свідчить те, що в 2015 році Єльський університет відмовився від власного вступного курсу програмування для першокурсників на користь використання курсу CS50 в своєму навчальному процесі! Станом на 2015 рік офлайн версія CS50 також є найпопулярнішим курсом за вибором в Гарвардському університеті.\nКурс розрахований як на повних новачків, так і на тих слухачів, хто вже має невеликий стартовий досвід в програмуванні.", categories: ["Програмування"], url: "https://courses.prometheus.org.ua/courses/Prometheus/CS50/2016_T1/about")
    }
    
    func addCourse(title: String, description: String, categories: [String], url: String) {
        let course: [String: Any] = ["title": title, "description": description, "categories": categories, "url": url]

        Firestore.firestore().collection("ukrainian/Courses/Collection").addDocument(data: course) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add course", message: error.localizedDescription)
                }
            }
        }
    }
    
    func addTestBooks() {
        addBook(title: "«Поштовх. Як допомогти людям зробити правильний вибір»", description: "Приймати рішення — це наче шукати потрібні двері у закручених коридорах багатоповерхового будинку. Тому й не дивно, що ми часто опиняємося не там, де хотіли б.\nЩоб вирішити цю проблему, Талер і Санстейн пропонують концепцію поштовхів, або наджів. Це м’який спосіб вплинути на вибір людини, не вдаючись до маніпуляцій, заборон чи наказів. З їхньою допомогою можна сприяти розумним покупкам та інвестиціям, економії електроенергії, безпеці на дорозі, вживанню здорової їжі та багатьом іншим корисним речам. Тобто підштовхнути людину до «правильних» дверей, зберігаючи свободу вибору кожного.", author: "Річард Талер, Кас Санстейн", categories: [Category.psychology.rawValue, Category.economy.rawValue, Category.sociology.rawValue], imageURL: "https://nashformat.ua/files/products/poshtovkh-yak-dopomohty-liudiam-zrobyty-pravylnyi-vybir-709043.400x500w.jpeg")
    }
    
    func addBook(title: String, description: String, author: String, categories: [String], imageURL: String?) {
        var bookDocument: [String: Any] = ["title": title, "description": description, "author": author, "categories": categories]
        if let imageURL = imageURL {
            bookDocument["imageUrl"] = imageURL
        }
        Firestore.firestore().collection("ukrainian/Books/Collection").addDocument(data: bookDocument) { error in
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
        Firestore.firestore().document("ukrainian/Books").setData(categoriesField) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add categories", message: error.localizedDescription)
                }
            }
        }
    }
    
    func addInfoText() {
        let infoText = ["text": "\tЗамислюєтеся інколи, що хотіли б розвиватися, але поки не знаєте, з чого почати і куди рухатись? Цей застосунок створено саме для того, щоб у цьому Вам допомогти.\n\tМи лише починаємо, отож Ваші поради та зауваження дуже важливі! Ви можете надсилати їх нам, скориставшись формою нижче. Дякуємо!"]
        Firestore.firestore().document("ukrainian/info").setData(infoText) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to add infoText", message: error.localizedDescription)
                }
            }
        }
    }
}
