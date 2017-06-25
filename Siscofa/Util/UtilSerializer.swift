//
//  UtilSerializer.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 23/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation

class UtilSerializer {
    
    let userArchive:String
    
    init() {
        let userDirs = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let dir = userDirs[0]
        //mealsArchive = "\(dir)/eggplant-brownie-meals.dados"
        userArchive = "\(dir)/user.dados"
    }
    
    func save(_ user:Usuario) {
        NSKeyedArchiver.archiveRootObject(user, toFile: userArchive)
    }
    
    func load() -> Usuario {
        if let loaded = NSKeyedUnarchiver.unarchiveObject(withFile: userArchive) {
            let usuario = loaded as! Usuario
            return usuario
        }
        return Usuario()
    }
    
}
