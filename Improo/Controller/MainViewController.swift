//
//  MainViewController.swift
//  Improo
//
//  Created by 3axap on 27.09.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView?
    @IBOutlet weak var sectionsTabBar: UITabBar?
    @IBOutlet weak var categoriesBarButton: UIBarButtonItem?
    
    var databaseReference: Firestore!

    var sectionItems = [Item]() {
        didSet {
            itemsTableView?.reloadData()
        }
    }
    
    var sectionCategories: [String]?
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title

        databaseReference = Firestore.firestore()

        //Load categories
        databaseReference.document("Books/Categories").getDocument { (document, error) in
            guard error == nil, let categories = document?.data()["All"] as? [String] else { return }
            self.sectionCategories = categories
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories ?? []
        categoriesViewController.selectAction = { category in
            self.selectedCategory = category
            sender?.title = category
        }
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "improoItemCell") ?? UITableViewCell()
        cell.textLabel?.text = sectionItems[indexPath.row].title
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: SHOW ITEM
    }

    //MARK: - UITabBarDelegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
