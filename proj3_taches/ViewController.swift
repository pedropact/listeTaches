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
    
    // Le chemim pour sauvegarder les données sur le serveur
    var urlToSend = "http://localhost/dashboard/pedro/php_json/add.php?json=["
    //var urlToSend = "http://localhost/dashboard/geneau/poo2/add.php?json=["
   
    // Le chemin de téléchargement des données du serveur
    let requestURL: NSURL = NSURL(string: "http://localhost/dashboard/pedro/php_json/data.json")!
    //let requestURL: NSURL = NSURL(string: "http://localhost/dashboard/geneau/poo2/data.json")!
    
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
    
    // Bouton pour ajouter des tâches à la liste
    // Si le champ de text est vide ou avec un espace, il y a un message de erreur.
    // Si l’utilisateur a fourni avec une tache, la méthode "addActivity" est appelée
    @IBAction func btAdd(_ sender: UIButton) {
        if tfAdd.text == "" || tfAdd.text == " " {
            let refreshAlert = UIAlertController(title: "Alerte !", message: "Insérer une tache !", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        } else {
            addActivity()
        }
    }
    //----------------------------------------------------------------------

    // Méthode pour ajouter une tâche à la liste
    func addActivity() {
        addObject.addValue(keyToAdd: tfAdd.text!)
        addObject.parseDict()
        tableview.reloadData()
        tfAdd.text = ""
        hideKeybord()
    }
    
    //----------------------------------------------------------------------
    
    // Boutton pour sauvegarder la liste sur le serveur
    // Demande à l'utilisateur s'il souhaite enregistrer la liste
    // Se la réponse est "oui", la méthode "save()" est appelée
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
    
    // Méthode qui sauvegarde la liste de tâches au serveur (dans ce cas, au fichier data.jason)
    // La méthode remplacera complètement la liste qui se trouve sur le serveur
    func save() {
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
    
    // Méthode qui remplace les caractères qui seront conservés sur le serveur
    // afin qu'il n'y ait aucune erreur dans le fichier
    func replaceChars(originalStr: String, what: String, byWhat: String) -> String {
        return originalStr.replacingOccurrences(of: what, with: byWhat)
    }
    //----------------------------------------------------------------------
    
    // Boutton pour télécharger la liste qu'est sur le serveur
    // Demande à l'utilisateur s'il souhaite désélectionner complètement la liste des tâches sélectionnées
    // Se la réponse est "oui", la méthode "resetListe" est appelée
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
    
    // Méthode qui télécharge la liste de tâches qu'est sur le serveur
    // La méthode remplacera complètement la liste sur le téléphone
    func load() {
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
                    //print(json)
                    
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
                    var index = 0
                    for key in keys{
                        for _ in values{
                            dictValues[key] = values[index]
                        }
                        self.addObject.addValue(keyToAdd: key)
                        index += 1
                    }
                    
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
    
    // Boutton pour désélectionner tout la liste
    // Demande à l'utilisateur s'il souhaite désélectionner complètement la liste des tâches sélectionnées
    // Se la réponse est "oui", la méthode "resetListe" est appelée
    @IBAction func btReset(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Effacer", message: "Effacer la liste des tâches sélectionnées ?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            self.resetList()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)    }
    //----------------------------------------------------------------------
    
    // Désélectionne complètement la liste des tâches qui sont sélectionnées
    func resetList() {
        for i in 0..<addObject.dictionnary.count {
            if Array( addObject.dictionnary.values)[i] {
                addObject.dictionnary[Array( addObject.dictionnary.keys)[i]] = false
                Singleton.singletonInstance.saveData()
                tableview.backgroundColor = UIColor.clear
            }
        }
        addObject.saveToSingleton()
        tableview.reloadData()
    }
    //----------------------------------------------------------------------
    
    // Désactiver le clavier
    func hideKeybord() {
        tfAdd.resignFirstResponder()
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.clear
        return addObject.dictionnary.count
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"proto")
        cell.textLabel!.text = addObject.keys[indexPath.row]
        cell.textLabel?.textColor = UIColor.lightGray
        cell.backgroundColor = UIColor.clear
        return cell
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Array(addObject.dictionnary.values)[indexPath.row] {
            cell.backgroundColor = UIColor.black
        }
    }
    //----------------------------------------------------------------------
    
    // Méthode pour gérer la TableView
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
    
    // Méthode pour gérer la TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            addObject.removeValue(keyToRemove: addObject.keys[indexPath.row])
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //----------------------------------------------------------------------
}
