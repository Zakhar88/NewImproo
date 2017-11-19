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
    //@IBOutlet var randomItemBarButton: UIBarButtonItem!
    @IBOutlet var categoriesBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 15.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    
    var books: [Item]?
    var booksCategories: [String]?
    
    var courses: [Item]?
    var coursesCategories: [String]?
    
    var activities: [Item]?
    var activitiesCategories: [String]?
    
    var entertainmens: [Item]?
    var entertainmensCategories: [String]?
    
    var selectedCategory = FirestoreManager.allCategories
    var itemsCollectioViewDataSource: ItemsCollectionViewDataSource!
    
    var sectionItems: [Item]? {
        switch selectedSection {
        case .About: return []
        case .Activities: return activities
        case .Books: return books
        case .Courses: return courses
        case .Entertainment: return entertainmens
        }
    }
    
    var selectedItems: [Item] {
        get {
            guard let sectionItems = sectionItems else { return [Item]() }
            if selectedCategory != FirestoreManager.allCategories {
                return sectionItems.filter({$0.categories.contains(selectedCategory)})
            } else {
                return sectionItems
            }
        }
    }
    
    var sectionCategories: [String]? {
        switch selectedSection {
        case .About: return []
        case .Activities: return activitiesCategories
        case .Books: return booksCategories
        case .Courses: return coursesCategories
        case .Entertainment: return entertainmensCategories
        }
    }
    
    var selectedSection: Section = .Books {
        didSet {
            guard oldValue != selectedSection else { return }
            self.title = selectedSection.ukrainianTitle
            itemsCollectionView.reloadData()
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title
        
        loadDocuments()
        //subscribeForUpdates()
        
        itemsCollectioViewDataSource = ItemsCollectionViewDataSource(delegate: self)
        itemsCollectionView.dataSource = itemsCollectioViewDataSource
        
        sectionsTabBar.tintColor = UIColor.mainThemeColor
    }
    
    // MARK: - Functions
    
    func checkAllDataExisting() {
        if activities != nil, books != nil, courses != nil, entertainmens != nil {
            self.activityIndicatorView?.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func selectRandomItem() {
        guard selectedItems.count > 0 else { return }
        let randomItemIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectedItems.count))), section: 0)
        itemsCollectionView.selectItem(at: randomItemIndexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView(itemsCollectionView, didSelectItemAt: randomItemIndexPath)
    }
    
    // MARK: - IBActions
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories ?? []
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
        FirestoreManager.shared.loadCategories(forSection: .Activities) { (categories, _) in
            self.activitiesCategories = categories
        }
        FirestoreManager.shared.loadCategories(forSection: .Books) { (categories, _) in
            self.booksCategories = categories
        }
        FirestoreManager.shared.loadCategories(forSection: .Courses) { (categories, _) in
            self.coursesCategories = categories
        }
        FirestoreManager.shared.loadCategories(forSection: .Entertainment) { (categories, _) in
            self.entertainmensCategories = categories
        }
        
        //Load items
        FirestoreManager.shared.loadDocuments(forSection: .Activities) { (items, error) in
            self.activities = items
            if self.selectedSection == .Activities {
                self.itemsCollectionView.reloadData()
            }
            self.checkAllDataExisting()
        }
        FirestoreManager.shared.loadDocuments(forSection: .Books) { (items, error) in
            self.books = items
            if self.selectedSection == .Books {
                self.itemsCollectionView.reloadData()
            }
            self.checkAllDataExisting()
        }
        FirestoreManager.shared.loadDocuments(forSection: .Courses) { (items, error) in
            self.courses = items
            if self.selectedSection == .Courses {
                self.itemsCollectionView.reloadData()
            }
            self.checkAllDataExisting()
        }
        FirestoreManager.shared.loadDocuments(forSection: .Entertainment) { (items, error) in
            self.entertainmens = items
            if self.selectedSection == .Entertainment {
                self.itemsCollectionView.reloadData()
            }
            self.checkAllDataExisting()
        }
    }
}

extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let newSection = Section(ukrainianTitle: item.title) else { return }
        selectedSection = newSection
    }
}
