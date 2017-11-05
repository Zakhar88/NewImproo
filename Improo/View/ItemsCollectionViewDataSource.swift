//
//  ItemsCollectionViewDataSource.swift
//  Improo
//
//  Created by Zakhar Garan on 05.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

protocol ItemsCollectionViewDelegate {
    var items: [Item] { get }
}

class ItemsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var delegate: ItemsCollectionViewDelegate
    
    init(delegate: ItemsCollectionViewDelegate) {
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.item =  delegate.items[indexPath.item]
        return cell
    }
}
