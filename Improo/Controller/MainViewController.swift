//
//  MainViewController.swift
//  Improo
//
//  Created by 3axap on 27.09.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class MainViewController: AdvertisementViewController {
    
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
    private var filteredSectionItems: [Item] {
        get {
            if isFiltering(), let searchText = navigationItem.searchController?.searchBar.text?.lowercased() {
                return sectionItems.filter({ item -> Bool in
                    return item.title.lowercased().contains(searchText) || (item.author?.lowercased().contains(searchText) == true)
                    })
            } else {
                return sectionItems
            }
        }
    }
    private var selectedCategory = FirestoreManager.allCategories
    
    private var selectedSectionItems: [Item] {
        get {
            if selectedCategory != FirestoreManager.allCategories {
                return filteredSectionItems.filter({$0.categories.contains(selectedCategory)})
            } else {
                return filteredSectionItems
            }
        }
    }
    
    private var sectionCategories = [String]() {
        didSet {
            if let allCategories = sectionCategories.first { //First category always should be "All Categories", sets in FirestoreManager
                categoriesBarButton?.title = allCategories
                selectedCategory = allCategories
            }
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
        // addSearchController() - for future versions
    }
    
    // MARK: - Functions
    
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
        navigationItem.searchController = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 1
            self.itemsTableView?.alpha = 0
        }) { _ in
            self.itemsTableView?.isHidden = true
        }
    }
    
    private func hideAboutView() {
        navigationItem.leftBarButtonItem = randomItemBarButton
        navigationItem.rightBarButtonItem = categoriesBarButton

        self.itemsTableView?.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 0
            self.itemsTableView?.alpha = 1
        })
    }
    
    private func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Пошук"
        searchController.searchBar.setValue("Відмінити", forKey:"_cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        return navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return navigationItem.searchController?.isActive == true && !searchBarIsEmpty()
    }
    
    // MARK: - IBActions
    
    @IBAction func selectRandomItem(_ sender: UIBarButtonItem?) {
        guard selectedSectionItems.count > 0 else { return }
        let randomItemIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectedSectionItems.count))), section: 0)
        itemsTableView?.selectRow(at: randomItemIndexPath, animated: true, scrollPosition: .none)
        self.tableView(itemsTableView!, didSelectRowAt: randomItemIndexPath)
    }
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories
        categoriesViewController.selectAction = { category in
            self.selectedCategory = category
            sender?.title = category
            self.itemsTableView?.reloadData()
        }
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    //MARK: - Firebase
    
    private func loadDocuments() {
        
        activityIndicatorView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Load categories
        FirestoreManager.shared.loadCategories(forSection: selectedSection) { (categories, error) in
            guard error == nil, let categories = categories else {
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

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        itemsTableView?.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.item = selectedSectionItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController else { return }
        itemViewController.selectedItem = selectedSectionItems[indexPath.row]
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}

extension MainViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let newSection = Section(ukrainianTitle: item.title) else { return }
        selectedSection = newSection
    }
}
