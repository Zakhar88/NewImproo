//
//  FirestoreManager.swift
//  Improo
//
//  Created by Zakhar Garan on 19.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import Firebase

class FirestoreManager {
    static let shared = FirestoreManager()
    static let allCategoriesTitle = "Усі категорії"
    
    private let databaseReference: Firestore!
    
    var settings = Settings()
    var language: Language = .ukrainian
    
    private init() {
        databaseReference = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = settings
    }
    
    func getSettings(completion: @escaping (Settings?, Error?)->()) {
        databaseReference.document("\(language.rawValue)/Settings").addSnapshotListener { (snapshot, error) in
            DispatchQueue.main.async {
                guard let snapshot = snapshot else {
                    completion(nil, error)
                    return
                }
                self.settings = Settings(documentSnapshot: snapshot)
                completion(self.settings, nil)
            }
        }
    }
    
    func loadCategories(forSection section: Section, completion: @escaping ([String]?, Error?)->()) {
        databaseReference.document("ukrainian/\(section.rawValue)").getDocument { (documentSnaphot, error) in
            guard documentSnaphot?.exists == true, var categories = documentSnaphot?.data()?["Categories"] as? [String] else {
                completion(nil, error)
                return
            }
            categories.insert(FirestoreManager.allCategoriesTitle, at: 0)
            DispatchQueue.main.async {
                completion(categories, nil)
            }
        }
    }
    
    func loadDocuments(forSection section: Section, completion: @escaping ([Item]?, Error?)->()) {
        databaseReference.collection("ukrainian/\(section.rawValue)/Collection").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                completion(nil, error)
                return
            }
            DispatchQueue.main.async {
                completion(documents.flatMap({Item(documentSnapshot: $0, section: section)}).sorted{$0.title < $1.title}, nil)
            }
        }
    }
    
    func subscribeForUpdates(forSection section: Section, completion: @escaping (Item?, DocumentChangeType?, Error?)->()) {
        databaseReference.collection("ukrainian/\(section.rawValue)/Collection").addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else {
                completion(nil, nil, error)
                return
            }
            querySnapshot.documentChanges.forEach({ documentChange in
                completion(Item(documentSnapshot: documentChange.document, section: section), documentChange.type, nil)
            })
        }
    }
    
    func uploadMessage(messageText: String, nickname: String? = nil, completion: @escaping (Error?)->()) {
        var data = ["text": messageText]
        if let nickname = nickname {
            data["nickname"] = nickname
        }
        databaseReference.collection("messages").addDocument(data: data) { error in
            completion(error)
        }
    }
    
    func uploadError(_ error: Error?) {
        guard let error = error else { return }
        let data = ["description": error.localizedDescription] //Add additional data, like device ID
        databaseReference.collection("errors").addDocument(data: data)
    }
}
