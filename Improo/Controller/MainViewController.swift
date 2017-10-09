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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var itemsTableView: UITableView?
    @IBOutlet weak var sectionsTabBar: UITabBar?
    @IBOutlet var categoriesBarButton: UIBarButtonItem?
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView?

    //@IBOutlet weak var randomItemBarButton: UIBarButtonItem?

    // MARK: - Properties
    
    var databaseReference: Firestore!
    var selectedCategory: String?
    
    var sectionCategories: [String]? {
        didSet {
            navigationItem.rightBarButtonItem = sectionCategories == nil ? nil : categoriesBarButton
        }
    }

    var sectionItems = [Item]() {
        didSet {
            itemsTableView?.reloadData()
        }
    }
    
    var selectedSection: Section = .Books {
        didSet {
            self.title = selectedSection.ukrainianTitle
            loadDocuments()
        }
    }
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksBarItem = sectionsTabBar?.items?.first
        sectionsTabBar?.selectedItem = booksBarItem
        title = booksBarItem?.title

        databaseReference = Firestore.firestore()
        loadDocuments()
    }
    
    // MARK: - Funcrions
    
    private func changeSectionTo(_ newSectionName: String) {
        databaseReference.document("Books/Categories").getDocument { (document, error) in
            guard error == nil, let categories = document?.data()["All"] as? [String] else { return }
            self.sectionCategories = categories
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func selectCategory(_ sender: UIBarButtonItem?) {
        guard let categoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        
        categoriesViewController.categoires = sectionCategories ?? []
        categoriesViewController.selectAction = { category in
            self.selectedCategory = category
            sender?.title = category
        }
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "improoItemCell") ?? UITableViewCell()
        cell.textLabel?.text = sectionItems[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: SHOW ITEM
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
        
        //Try to load categories
        databaseReference.document("publicData/\(selectedSection.rawValue)").getDocument { (documentSnaphot, error) in
            guard documentSnaphot?.exists == true, var categories = documentSnaphot?.data()["categories"] as? [String] else {
                self.sectionCategories = nil
                return
            }
            categories.insert("Усі категорії", at: 0)
            DispatchQueue.main.async {
                self.sectionCategories = categories
                self.categoriesBarButton?.title = categories.first
            }
        }
        
        //Load items
        databaseReference.collection("publicData/\(selectedSection.rawValue)/Collection").getDocuments { (querySnaphot, error) in
            self.activityIndicatorView?.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            guard let documents = querySnaphot?.documents.map({Item(dictionary: $0.data())}) as? [Item] else { return }
//            DispatchQueue.main.async {
//                self.sectionItems = documents
//            }
        }
    }
    
    private func addListener() {
        databaseReference.document("").addSnapshotListener { (documentSnapshot, error) in
            
        }
    }

    
    
    
    
    
    
    
}
