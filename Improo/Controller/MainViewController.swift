//
//  MainViewController.swift
//  Improo
//
//  Created by 3axap on 27.09.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: AdvertisementViewController, ItemsCollectionViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var sectionsTabBar: UITabBar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var randomItemBarButton: UIBarButtonItem!
    @IBOutlet var categoriesBarButton: UIBarButtonItem!
    @IBOutlet weak var aboutView: AboutView?
    
    // MARK: - Properties
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    
    var books = [Item]()
    var courses = [Item]()
    var activities = [Item]()
    var entertainmens = [Item]()

    private var selectedCategory = FirestoreManager.allCategories
    
    var items: [Item] {
        return selectedSectionItems
    }

    private var sectionItems = [Item]() {
        didSet {
            itemsCollectionView?.reloadData()
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
    
    var selectedSectionItems: [Item] {
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
    
    var itemsCollectioViewDataSource: ItemsCollectionViewDataSource!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title
        
        loadDocuments()
        setupAboutView()
        subscribeForUpdates()
        
        itemsCollectioViewDataSource = ItemsCollectionViewDataSource(delegate: self)
        itemsCollectionView.dataSource = itemsCollectioViewDataSource
                
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
        setupAboutView()
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        navigationItem.searchController = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 1
            self.itemsCollectionView?.alpha = 0
        }) { _ in
            self.itemsCollectionView?.isHidden = true
        }
    }
    
    private func hideAboutView() {
        navigationItem.leftBarButtonItem = randomItemBarButton
        navigationItem.rightBarButtonItem = categoriesBarButton

        self.itemsCollectionView?.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 0
            self.itemsCollectionView?.alpha = 1
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
        itemsCollectionView?.selectItem(at: randomItemIndexPath, animated: true, scrollPosition: .centeredVertically)
        //self.itemsCollectionView
    }
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories
        categoriesViewController.selectAction = { category in
            self.selectedCategory = category
            sender?.title = category
            self.itemsCollectionView?.reloadData()
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
    
    private func subscribeForUpdates() {
        FirestoreManager.shared.sunscribeForUpdates(forSection: selectedSection) { (item, changeType, error) in
            guard let item = item, let changeType = changeType, error == nil else {
                self.showError(error)
                return
            }
            switch changeType {
                case .added:
                    self.sectionItems.insert(item, at: 0)
                case .modified:
                    if let index = self.sectionItems.index(where: {$0.id == item.id}) {
                        self.sectionItems[index] = item
                }
                case .removed:
                    if let index = self.sectionItems.index(where: {$0.id == item.id}) {
                        self.sectionItems.remove(at: index)
                }
            }
            self.itemsCollectionView?.reloadData()
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        itemsCollectionView?.reloadData()
    }
}

extension MainViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let newSection = Section(ukrainianTitle: item.title) else { return }
        selectedSection = newSection
    }
}
