//
//  Add.swift
//  proj3_taches
//
//  Created by Pedro Teixeira on 17/08/17.
//  Copyright © 2017 Pedro Teixeira. All rights reserved.
//

import Foundation

class Add { //ok
    //----------------------------------------------------------------------
    
    var dictionnary: [String: Bool]!
    var keys: [String] = []
    var values: [Bool] = []
    //----------------------------------------------------------------------
    
    init() {
        if let dict = Singleton.singletonInstance.dictionnary {
            dictionnary = dict
        } else {
            dictionnary = [:]
        }
        parseDict()
    }
   //----------------------------------------------------------------------
    
    func parseDict() {
        keys = []
        values = []
        for (k, v) in dictionnary {
            keys.append(k)
            values.append(v)
        }
    }
    //----------------------------------------------------------------------
    
    func addValue(keyToAdd: String) {
        dictionnary[keyToAdd] = false
        saveToSingleton()
    }
    //----------------------------------------------------------------------
    
    func removeValue(keyToRemove: String) {
        dictionnary[keyToRemove] = nil
        saveToSingleton()
    }
    //----------------------------------------------------------------------
    
    func saveToSingleton() {
        
        
        parseDict()
        Singleton.singletonInstance.dictionnary = dictionnary
        Singleton.singletonInstance.saveData()
    }
    //----------------------------------------------------------------------
}
