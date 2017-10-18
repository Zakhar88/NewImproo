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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet var randomItemBarButton: UIBarButtonItem?
    @IBOutlet var categoriesBarButton: UIBarButtonItem?
    @IBOutlet weak var aboutView: AboutView?
    
    //@IBOutlet weak var randomItemBarButton: UIBarButtonItem?
    
    // MARK: - Properties
    
    private let allCategories = "Усі категорії"
    
    var databaseReference: Firestore!
    private var sectionItems = [Item]()
    private var selectedCategory: String?
    
    private var selectedSectionItems: [Item] {
        get {
            if let selectedCategory = selectedCategory, selectedCategory != allCategories {
                return sectionItems.filter({$0.categories.contains(selectedCategory)})
            } else {
                return sectionItems
            }
        }
    }
    
    private var sectionCategories: [String]? {
        didSet {
            navigationItem.rightBarButtonItem = sectionCategories == nil ? nil : categoriesBarButton
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
        
        configureFirestore()
        loadDocuments()
        
        //TODO: Load info text
        aboutView?.infoTextLabel?.text = "\tЗадумувалися інколи що хотілося б розвиватися, але не знаєте як, з чого почати і куди рухатись? Цей додаток створения саме для того, щоб допомогти Вам у цьому. Ми лише починаємо, і ваші поради та зауваження дуже важливі! Нижче ви можете надіслати їх нам. Дякуємо!"
    }
    
    // Functions
    
    private func configureFirestore() {
        FirebaseApp.configure()
        databaseReference = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = settings
    }
    
    
    func showAboutView() {
        aboutView?.isHidden = false
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 1
        })
    }
    
    func hideAboutView() {
        navigationItem.leftBarButtonItem = randomItemBarButton
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutView?.alpha = 0
        }) { (_) in
            self.aboutView?.isHidden = true
        }
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
        let cell: UITableViewCell
        if let selectedBook = selectedSectionItems[indexPath.row] as? Book {
            cell = tableView.dequeueReusableCell(withIdentifier: "improoBookCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "improoBookCell")
            cell.detailTextLabel?.text = selectedBook.author
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "improoItemCell") ?? UITableViewCell()
        }
        cell.textLabel?.text = selectedSectionItems[indexPath.row].title
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
        
        //Try to load categories
        databaseReference.document("ukrainian/\(selectedSection.rawValue)").getDocument { (documentSnaphot, error) in
            guard documentSnaphot?.exists == true, var categories = documentSnaphot?.data()["Categories"] as? [String] else {
                self.sectionCategories = nil
                return
            }
            categories.insert(self.allCategories, at: 0)
            DispatchQueue.main.async {
                self.sectionCategories = categories
                self.categoriesBarButton?.title = categories.first
            }
        }
        
        //Load items
        databaseReference.collection("ukrainian/\(selectedSection.rawValue)/Collection").getDocuments { (querySnapshot, error) in
            self.activityIndicatorView?.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            switch self.selectedSection {
            case .Books:
                self.sectionItems = querySnapshot!.documents.flatMap({Book(dictionary: $0.data())})
                self.itemsTableView?.estimatedRowHeight = 100
            default:
                self.sectionItems = querySnapshot!.documents.flatMap({Item(dictionary: $0.data())})
                self.itemsTableView?.estimatedRowHeight = 50
            }
            
            DispatchQueue.main.async {
                self.itemsTableView?.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    
}
