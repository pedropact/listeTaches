//
//  Add.swift
//  proj3_taches
//
//  Created by Pedro Teixeira on 17/08/17.
//  Copyright © 2017 Pedro Teixeira. All rights reserved.
//

import Foundation

class Add {
    
    // ---------------------------------------------------------------
    // MARK: - PROPRIÉTÉS
    var dictionnary: [String: Bool]!
    var keys: [String] = []
    var values: [Bool] = []
    
    init() {
        if let dict = Singleton.singletonInstance.dictionnary {
            dictionnary = dict
        } else {
            dictionnary = [:]
        }
        parseDict()
    }
   
    // ---------------------------------------------------------------
    // MARK: - MÉTHODES
    
    // ---------------------------------------------------------------
    /*
     . Méthode: parseDict
     .
     . - Méthode pour sauvegarder les données dans le dictionnaire
     .
     */
    func parseDict() {
        keys = []
        values = []
        for (k, v) in dictionnary {
            keys.append(k)
            values.append(v)
        }
    }

    // ---------------------------------------------------------------
    /*
     . Méthode: addValue
     .
     . - Méthode pour ajouter les  données dans le dictionnaire
     .
     */
    func addValue(keyToAdd: String) {
        dictionnary[keyToAdd] = false
        saveToSingleton()
    }

    // ---------------------------------------------------------------
    /*
     . Méthode: removeValue
     .
     . - Méthode pour supprimer les données dans le dictionnaire
     .
     */
    func removeValue(keyToRemove: String) {
        dictionnary[keyToRemove] = nil
        saveToSingleton()
    }

    // ---------------------------------------------------------------
    /*
     . Méthode: saveToSingleton
     .
     . - Méthode pour sauvegarder les données dans le Singleton
     .
     */
    func saveToSingleton() {
        parseDict()
        Singleton.singletonInstance.dictionnary = dictionnary
        Singleton.singletonInstance.saveData()
    }
}
