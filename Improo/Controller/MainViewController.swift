//
//  MainViewController.swift
//  Improo
//
//  Created by 3axap on 27.09.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView?
    @IBOutlet weak var sectionsTabBar: UITabBar?
    
    var firebaseManager: FirebaseManager!

    var selectedSectionItems = [Item]() {
        didSet {
            itemsTableView?.reloadData()
        }
    }
    
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseManager = FirebaseManager.sharedManager
        firebaseManager.loadItems()
        
        selectedSectionItems.append(Item(name: "One"))
        selectedSectionItems.append(Item(name: "Two"))
        selectedSectionItems.append(Item(name: "Three"))
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title        
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "improoItemCell") ?? UITableViewCell()
        cell.textLabel?.text = selectedSectionItems[indexPath.row].title
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
