//
//  SecondViewController.swift
//  proj3_taches
//
//  Created by Pedro Teixeira on 17/08/17.
//  Copyright © 2017 Pedro Teixeira. All rights reserved.
//

import Foundation

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var dataFirstTableview = [""]
    let addObject = Add()
    //----------------------------------------------------------------------
    
    // Méthode pour charger la view avec les tâches séléctionnées dans
    // la première view
    override func viewDidLoad() {
        dataFirstTableview.remove(at: 0)
        for(b, a) in Singleton.singletonInstance.dictionnary{
            if a == true {
                dataFirstTableview.append(b)
            }
        }
        super.viewDidLoad()
    }
    //----------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.clear
        return dataFirstTableview.count
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"proto")
        for(_, a) in Singleton.singletonInstance.dictionnary{
            if a == true {
                cell.textLabel!.text = Array(dataFirstTableview)[indexPath.row]
            }
        }
        cell.textLabel?.textColor = UIColor.lightGray
        cell.backgroundColor = UIColor.clear
        return cell
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor.black
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            addObject.dictionnary[dataFirstTableview[indexPath.row]] = false
            addObject.saveToSingleton()
            dataFirstTableview.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //----------------------------------------------------------------------
}










