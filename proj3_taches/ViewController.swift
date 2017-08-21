//
//  ViewController.swift
//  proj3_taches
//
//  Created by Pedro Teixeira on 17/08/17.
//  Copyright © 2017 Pedro Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //----------------------------------------------------------------------
    
    @IBOutlet weak var tfAdd: UITextField!
    @IBOutlet weak var tableview: UITableView!
    let addObject = Add()
    //----------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //----------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //----------------------------------------------------------------------
    
    @IBAction func btAdd(_ sender: UIButton) {
        addObject.addValue(keyToAdd: tfAdd.text!)
        addObject.parseDict()
        tableview.reloadData()
        tfAdd.text = ""
        hideKeybord()
    }
    //----------------------------------------------------------------------
    
    @IBAction func btSave(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Sauvegarder", message: "Envoyer les données au serveur ?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.save()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    //----------------------------------------------------------------------
    
    func save() {
        var urlToSend = "http://localhost/dashboard/pedro/php_json/add.php?json=["
        //var urlToSend = "http://localhost/dashboard/geneau/poo2/add.php?json=["
        
        var counter = 0
        let total = addObject.dictionnary.count
        for (a, b) in addObject.dictionnary {
            let noSpaces = replaceChars(originalStr: a, what: " ", byWhat: "_")
            counter += 1
            if counter < total {
                urlToSend += "/\(noSpaces)/,/\(b)/!"
            } else {
                urlToSend += "/\(noSpaces)/,/\(b)/"
            }
        }
        urlToSend += "]"
        
        let session = URLSession.shared
        let urlString = urlToSend
        let url = NSURL(string: urlString)
        let request = NSURLRequest(url: url! as URL)
        let dataTask = session.dataTask(with: request as URLRequest) {
            (data:Data?, response:URLResponse?, error:Error?) -> Void in
        }
        dataTask.resume()
    }
    //----------------------------------------------------------------------
    
    @IBAction func btLoad(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Télécharger", message: "Télécharger les données du serveur ?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.load()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    //----------------------------------------------------------------------
    
    func load() {
        let requestURL: NSURL = NSURL(string: "http://localhost/dashboard/pedro/php_json/data.json")!
        //let requestURL: NSURL = NSURL(string: "http://localhost/dashboard/geneau/poo2/data.json")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url:
            requestURL as URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Tout fonctionne correctement...")
                
                
                do{
                    let json = try JSONSerialization.jsonObject(with:
                        data!, options:.allowFragments)
                    print(json)
                    
                    var dictValues: [String: Bool] = [:]
                    var keys: [String] = []
                    var values: [Bool] = []
                    for (k, v) in json as! [String : String]  {
                        keys.append(k)
                        if v == "false" {
                            values.append(false)
                        } else {
                            values.append(true)
                        }
                    }
                    //----------------affecte les valeurs à tableView-------
                    var index = 0
                    for key in keys{
                        for _ in values{
                            dictValues[key] = values[index]
                        }
                        self.addObject.addValue(keyToAdd: key)
                        index += 1
                    }
                    //----------rafraichit la tableview
                    self.addObject.dictionnary = dictValues
                    
                    
                    Singleton.singletonInstance.dictionnary = dictValues
                    
                    self.addObject.parseDict()
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }catch {
                    print("Erreur Json: \(error)")
                }
            }
        }
        task.resume()
    }
    //----------------------------------------------------------------------
    
    @IBAction func btReset(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Effacer", message: "Effacer la liste des tâches sélectionnées ?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.resetList()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)    }
    //----------------------------------------------------------------------
    
    func resetList() {
        for i in 0..<addObject.dictionnary.count {
            if Array( addObject.dictionnary.values)[i] {
                addObject.dictionnary[Array( addObject.dictionnary.keys)[i]] = false
                tableview.backgroundColor = UIColor.clear
            }
        }
        tableview.reloadData()
    }
    
    //----------------------------------------------------------------------
    
    func hideKeybord() {
        tfAdd.resignFirstResponder()
    }
    //----------------------------------------------------------------------
    
    func replaceChars(originalStr: String, what: String, byWhat: String) -> String {
        return originalStr.replacingOccurrences(of: what, with: byWhat)
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.clear
        return addObject.dictionnary.count
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"proto")
        cell.textLabel!.text = addObject.keys[indexPath.row]
        cell.textLabel?.textColor = UIColor.lightGray
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Array(addObject.dictionnary.values)[indexPath.row] {
            cell.backgroundColor = UIColor.black
        }
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor.darkGray
        
        if !Array(addObject.dictionnary.values)[indexPath.row] {
            addObject.dictionnary[Array(addObject.dictionnary.keys)[indexPath.row]] = true
        } else {
            addObject.dictionnary[Array(addObject.dictionnary.keys)[indexPath.row]] = false
        }
        addObject.saveToSingleton()
        tableView.reloadData()
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            addObject.removeValue(keyToRemove: addObject.keys[indexPath.row])
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //---------------------
    
}
