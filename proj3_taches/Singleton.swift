//
//  Singleton.swift
//  proj3_taches
//
//  Created by Pedro Teixeira on 17/08/17.
//  Copyright © 2017 Pedro Teixeira. All rights reserved.
//

import Foundation

class Singleton {
    //----------------------------------------------------------------------
    
    static let singletonInstance = Singleton()
    var dictionnary: [String: Bool]!
    let userDefault = UserDefaults.standard
    //----------------------------------------------------------------------
    
    // Initialisaton du Singleton
    init() {
        if userDefault.object(forKey: "data") ==  nil {
            userDefault.setValue(dictionnary, forKey: "data")
        } else {
            dictionnary = userDefault.object(forKey: "data") as! [String : Bool]!
        }
    }
    //----------------------------------------------------------------------
    
    func saveData() {
        userDefault.setValue(dictionnary, forKey: "data")
    }
    //----------------------------------------------------------------------
}

