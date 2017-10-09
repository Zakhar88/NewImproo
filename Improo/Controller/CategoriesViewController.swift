//
//  CategoriesViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 04.10.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoires = [String]()
    var selectAction: ((String)->())?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoires.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") ?? UITableViewCell()
        cell.textLabel?.text = categoires[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectAction?(categoires[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
