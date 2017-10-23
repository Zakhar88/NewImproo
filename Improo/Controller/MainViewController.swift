//
//  MainViewController.swift
//  Improo
//
//  Created by 3axap on 27.09.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var itemsTableView: UITableView?
    @IBOutlet weak var sectionsTabBar: UITabBar?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet var randomItemBarButton: UIBarButtonItem?
    @IBOutlet var categoriesBarButton: UIBarButtonItem?
    @IBOutlet weak var aboutView: AboutView?
    
    // MARK: - Properties
        
    private var sectionItems = [Item]() {
        didSet {
            itemsTableView?.reloadData()
        }
    }
    private var selectedCategory: String?
    
    private var selectedSectionItems: [Item] {
        get {
            if let selectedCategory = selectedCategory, selectedCategory != FirestoreManager.allCategories {
                return sectionItems.filter({$0.categories.contains(selectedCategory)})
            } else {
                return sectionItems
            }
        }
    }
    
    private var sectionCategories: [String]! {
        didSet {
            categoriesBarButton?.title = sectionCategories?.first
        }
    }
    
    private var selectedSection: Section = .Books {
        didSet {
            guard oldValue != selectedSection else { return }
            self.title = selectedSection.ukrainianTitle
            
            if selectedSection == .About {
                showAboutView()
                return
            }
            
            if oldValue == .About {
                hideAboutView()
            }
            
            loadDocuments()
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title
        
        loadDocuments()
        setupAboutView()
    }
    
    // Functions
    
    private func setupAboutView() {
        FirestoreManager.shared.loadInfo { (infoText, error) in
            guard let infoText = infoText else {
                self.showError(error)
                return
            }
            self.aboutView?.infoTextLabel?.text = infoText
        }
        aboutView?.messageTextView?.placeholder = "Ваше повідомлення..."
    }
    
    private func showAboutView() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 1
            self.itemsTableView?.alpha = 0
        }) { _ in
            self.itemsTableView?.isHidden = true
        }
    }
    
    private func hideAboutView() {
        navigationItem.leftBarButtonItem = randomItemBarButton
        self.itemsTableView?.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 0
            self.itemsTableView?.alpha = 1
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func selectRandomItem(_ sender: UIBarButtonItem?) {
        let randomItemIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectedSectionItems.count))), section: 0)
        itemsTableView?.selectRow(at: randomItemIndexPath, animated: true, scrollPosition: .none)
        self.tableView(itemsTableView!, didSelectRowAt: randomItemIndexPath)
    }
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories ?? []
        categoriesViewController.selectAction = { category in
            self.selectedCategory = category
            sender?.title = category
            self.itemsTableView?.reloadData()
        }
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.item = selectedSectionItems[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController else { return }
        itemViewController.selectedItem = selectedSectionItems[indexPath.row]
        navigationController?.pushViewController(itemViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return selectedSection == .Books ? 77 : -1
    }
    
    // MARK: - UITabBarDelegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let newSection = Section(ukrainianTitle: item.title) else { return }
        selectedSection = newSection
    }
    
    //MARK: - Firebase
    
    private func loadDocuments() {
        
        activityIndicatorView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Load categories
        FirestoreManager.shared.loadCategories(forSection: selectedSection) { (categories, error) in
            guard error == nil else {
                self.showError(error)
                return
            }
            self.sectionCategories = categories
        }
        
        //Load items
        FirestoreManager.shared.loadDocuments(forSection: selectedSection) { (items, error) in
            self.activityIndicatorView?.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            guard let items = items else {
                self.showError(error)
                return
            }
            
            self.sectionItems = items
        }
    }
}
