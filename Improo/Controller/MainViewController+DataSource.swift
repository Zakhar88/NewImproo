//
//  MainViewController+DataSource.swift
//  Improo
//
//  Created by Zakhar Garan on 05.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController else { return }
        itemViewController.selectedItem = selectedSectionItems[indexPath.item]
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}
