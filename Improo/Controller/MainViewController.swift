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
    @IBOutlet weak var categoriesBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 15.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    
    var allSectionsData = [SectionData]()
    var itemsCollectioViewDataSource: ItemsCollectionViewDataSource!
    var selectedCategory = FirestoreManager.allCategoriesTitle {
        didSet {
            categoriesBarButton?.title = selectedCategory
            self.itemsCollectionView?.reloadData()
        }
    }
    
    var sectionItems: [Item]? {
        for sectionData in allSectionsData {
            if sectionData.section == selectedSection {
                return sectionData.items
            }
        }
        return nil
    }
    
    var selectedItems: [Item] {
        get {
            guard let sectionItems = sectionItems else { return [Item]() }
            if selectedCategory != FirestoreManager.allCategoriesTitle {
                return sectionItems.filter({$0.categories.contains(selectedCategory)})
            } else {
                return sectionItems
            }
        }
    }
    
    var sectionCategories: [String]? {
        for sectionData in allSectionsData {
            if sectionData.section == selectedSection {
                return sectionData.categories
            }
        }
        return nil
    }
    
    var selectedSection: Section = .Books {
        didSet {
            guard oldValue != selectedSection else { return }
            self.title = selectedSection.ukrainianTitle
            selectedCategory = FirestoreManager.allCategoriesTitle
            itemsCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionsTabBar.tintColor = UIColor.mainThemeColor
        itemsCollectioViewDataSource = ItemsCollectionViewDataSource(delegate: self)
        itemsCollectionView.dataSource = itemsCollectioViewDataSource
        setSections()

        //TODO: subscribeForUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //For fixing iOS bug: https://goo.gl/kB3YTB
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCategorySegue", let categoriesViewController = segue.destination as? CategoriesViewController {
            categoriesViewController.categoires = sectionCategories ?? []
            categoriesViewController.selectAction = { category in
                self.selectedCategory = category
            }
        }
    }
    
    // MARK: - Functions
    
    func endIgnoringEvents() {
        self.activityIndicatorView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        self.itemsCollectionView.reloadData()
    }
    
    func checkAllDataExisting() {
        if allSectionsData.count == sectionsTabBar.items?.count {
            endIgnoringEvents()
        }
    }
    
    //TODO: Add button for that
    func selectRandomItem() {
        guard selectedItems.count > 0 else { return }
        let randomItemIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectedItems.count))), section: 0)
        itemsCollectionView.selectItem(at: randomItemIndexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView(itemsCollectionView, didSelectItemAt: randomItemIndexPath)
    }
    
    //MARK: - Firebase
    
    private func setSections() {
        
        activityIndicatorView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        FirestoreManager.shared.getSettings { (settings, error) in
            guard let settings = settings else {
                self.showError(error)
                self.endIgnoringEvents()
                return
            }
            
            let sections = settings.sections
            var items = [UITabBarItem]()
            for (index, section) in sections.enumerated() {
                let tabBarItem = SectionTabBarItem(title: section.ukrainianTitle, image: UIImage(named: section.rawValue), tag: index)
                tabBarItem.section = section
                items.append(tabBarItem)
            }
            self.sectionsTabBar.setItems(items, animated: true)
            if let firstItem = self.sectionsTabBar.items?.first {
                self.sectionsTabBar.selectedItem = firstItem
                self.title = firstItem.title
            }
            self.loadDocuments(forSections: sections)
        }
    }
    
    private func loadDocuments(forSections sections: [Section]) {

        for section in sections{
            FirestoreManager.shared.loadDocuments(forSection: section) { (items, error) in
                guard let items = items else {
                    self.showError(error)
                    self.endIgnoringEvents()
                    return
                }
                let sectionData = SectionData(section: section, items: items)
                FirestoreManager.shared.loadCategories(forSection: section, completion: { (categories, error) in
                    guard let categories = categories else {
                        self.showError(error)
                        self.endIgnoringEvents()
                        return
                    }
                    sectionData.categories = categories
                    self.allSectionsData.append(sectionData)
                    self.checkAllDataExisting()
                })
            }
        }
    }
    
    func subscribeForUpdates() {
        //TODO: Create closure for managing updates
        //TODO: Add that closure to each section update func
    }
}

extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let newSection = (item as? SectionTabBarItem)?.section else { return }
        selectedSection = newSection
    }
}
